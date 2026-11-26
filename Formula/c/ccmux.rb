class Ccmux < Formula
  desc "Run all your AI coding agents in tmux"
  homepage "https://github.com/epilande/ccmux"
  url "https://github.com/epilande/ccmux/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "70735ea6561415e1c10fc3fa190d7f9860904d8d690a04447e02d7ff0c00c687"
  license "MIT"

  bottle do
    manifest_sha256 "b309ac3ace66ef9cdf0f6577855eefbc8429aae140cb8545a44b008fe33c42b2"
    sha256 arm64_golden_gate: "c7d22d839018ba275c2fbd79101e13a1a2c965feb7a33383aca0eda8633a0c78"
    sha256 arm64_tahoe:       "dc4c4333dca7046e0fcfa34c311e9f5efa46a56c436217bd6e09823c0734819b"
    sha256 arm64_sequoia:     "7d59b299538563d1eeedd876769b909de29a24ccc0954e4e47f50e89a375330b"
    sha256 arm64_linux:       "814c592642f629492b0468f494bd76fa7bbb8c84f7a0bc1a9008e1bb9a4ec2fc"
    sha256 x86_64_linux:      "9edcc5ca45984f5ff820ccd8d443a06a6b6173a6155ce776a00e6711ba3b2e03"
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
      bun_icu = Formula["bun"].dep("icu4c").to_formula
      icu = dep("icu4c").to_formula

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
