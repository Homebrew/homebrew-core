class Ccmux < Formula
  desc "Run all your AI coding agents in tmux"
  homepage "https://github.com/epilande/ccmux"
  url "https://github.com/epilande/ccmux/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "feb0d9eb4c16bc7f35bc63ecce25381a18cdc8888610d1c17117da8c80092c2a"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "64c526fd9478d0564f026884fe78df030bb0b8a2a951e16e21637ad95e01abf2"
    sha256 arm64_tahoe:       "e5cd255425435cab71584e530027c6787a3e4079243d2d415461614fb3a9f705"
    sha256 arm64_sequoia:     "114a449e9a04dcedb4768f29ab5a1a10374f906d0c4da7ea5839519d5847c9e1"
    sha256 arm64_linux:       "a7133aba24f66a252c546da949a793c161a27e631f0051d39cfa3591883ab990"
    sha256 x86_64_linux:      "fbfaf15de9c7c7d6441216a12531678f1bd3aa782321519db0304f8cadeebab7"
  end

  depends_on "bun" => :build
  depends_on "tmux"

  on_macos do
    depends_on xcode: ["16.0", :build]
    depends_on "xcodegen" => :build
  end

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula
      icu = deps.find { |dep| dep.name.start_with?("icu4c") }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
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
