class Ccmux < Formula
  desc "Run all your AI coding agents in tmux"
  homepage "https://github.com/epilande/ccmux"
  url "https://github.com/epilande/ccmux/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "e5e44bc18eab59ee68ffa33a398c6a254e11831b52a9c649201f36faaf3ee80b"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "c156cde086c051602367eb02efc3824e3c1fa64dbd9f3ef29212eb4310480f2b"
    sha256 arm64_tahoe:       "43335f70343f52d22f6e81f03315f53d0d8be1c0fa8024ab5e7546697ba67216"
    sha256 arm64_sequoia:     "1d8900d823f8eccb3305b277a0825d638d596b8e107aa49d0ab056afe2fac423"
    sha256 arm64_linux:       "95fe7911f3d06c780f4c598d17930fd378d42985c899ff902c9de34ae316a386"
    sha256 x86_64_linux:      "824ea0248b96e75c1f665600a34f43896cd1694b3b90fc1043375aad256dd37a"
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
