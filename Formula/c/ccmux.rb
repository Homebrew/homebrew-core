class Ccmux < Formula
  desc "Run all your AI coding agents in tmux"
  homepage "https://github.com/epilande/ccmux"
  url "https://github.com/epilande/ccmux/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "ecbaf344319e6422d9b187ca74797e737d6f2177f20bb8176798c025b9bd9eab"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "f31fff43b12f79a016faa9a189a1dbc746a5123ecd35cb3059dbcc24a2c2f69f"
    sha256 arm64_tahoe:       "c8d205ff33155194cfefa1326b601af0072d75dcd20896bfab7d4b102ad641cb"
    sha256 arm64_sequoia:     "b7052d0b1ff7f0b4970c395adb540e72320ee058b4769d9d877a08871d5a649f"
    sha256 arm64_linux:       "0feacaa042fa7a566260e5dcef92c0a401a118afb67882465ae221c0bf76a83e"
    sha256 x86_64_linux:      "5ecc65102b21fe1a45a8912ab723ddffe31d4e40af854e27d13ba2b8d536700f"
  end

  depends_on "bun" => :build
  depends_on "tmux"

  on_macos do
    depends_on xcode: ["16.0", :build]
    depends_on "xcodegen" => :build
  end

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula
      icu = deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "run", "build"

    # Without this the executable inherits the repository's bunfig.toml, whose
    # `preload` needs node_modules that aren't present at runtime.
    system "bun", "build", "dist/index.js", "--compile", "--no-compile-autoload-bunfig",
           "--outfile", bin/"ccmux"

    generate_completions_from_executable(bin/"ccmux", "completion")

    return unless OS.mac?

    # Native notification helper. ccmux resolves it at `../libexec/ccmux-notifier.app`
    # relative to its own executable.
    cd "notifier" do
      system "xcodegen", "generate"
      xcodebuild "-project", "ccmux-notifier.xcodeproj",
                 "-target", "ccmux-notifier",
                 "-configuration", "Release",
                 "SYMROOT=build",
                 "ARCHS=#{Hardware::CPU.arch}",
                 "ONLY_ACTIVE_ARCH=YES",
                 "CODE_SIGNING_ALLOWED=NO",
                 "MARKETING_VERSION=#{version}"
      libexec.install "build/Release/ccmux-notifier.app"

      # Notification permission is tied to the bundle's signature, so sign
      # ad hoc with the hardened runtime and the upstream entitlements.
      system "/usr/bin/codesign", "--force", "--sign", "-", "--options", "runtime",
             "--entitlements", "ccmux-notifier.entitlements", libexec/"ccmux-notifier.app"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccmux --version")

    # Keep config and state out of the real home directory.
    ENV["CCMUX_HOME"] = testpath/"ccmux"

    system bin/"ccmux", "config", "set", "theme", "nord"
    assert_match '"theme": "nord"', (testpath/"ccmux/ccmux.json").read
    assert_match 'theme = "nord"', shell_output("#{bin}/ccmux config get theme")

    return unless OS.mac?

    # Only `--version` runs without a window server; every other mode starts NSApplication.
    app = libexec/"ccmux-notifier.app"
    assert_equal version.to_s, shell_output("#{app}/Contents/MacOS/ccmux-notifier --version").strip
    assert_match "valid on disk",
                 shell_output("/usr/bin/codesign --verify --deep --strict --verbose=2 #{app} 2>&1")
  end
end
