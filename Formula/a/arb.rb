class Arb < Formula
  desc "GPU-accelerated terminal emulator built for AI coding"
  homepage "https://github.com/szj2ys/arb"
  url "https://github.com/szj2ys/arb/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ab62a5681327acd99f9cebf654e802710dcc8ccbf69b5adc6fc2c0dc182db49e"
  license "MIT"
  head "https://github.com/szj2ys/arb.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "openssl@3"
  depends_on :macos
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["PKG_CONFIG_PATH"] = [
      Formula["openssl@3"].opt_lib/"pkgconfig",
      Formula["freetype"].opt_lib/"pkgconfig",
      Formula["harfbuzz"].opt_lib/"pkgconfig",
      Formula["fontconfig"].opt_lib/"pkgconfig",
    ].join(":")

    system "cargo", "install", *std_cargo_args(path: "arb")
    system "cargo", "install", *std_cargo_args(path: "arb-gui")

    prefix.install "target/release/Arb.app"
    share.install "assets/shell-integration" if Dir.exist?("assets/shell-integration")
    share.install "assets/configs" if Dir.exist?("assets/configs")
  end

  def caveats
    <<~EOS
      arb has been installed!

      To use the GUI application:
        ln -s #{opt_prefix}/Arb.app /Applications

      To set up shell integration, run:
        arb init

      Or manually add to your shell config:
        # For zsh (~/.zshrc)
        eval "$(arb init zsh)"

        # For bash (~/.bashrc)
        eval "$(arb init bash)"

      Configuration file:
        ~/.config/arb/arb.lua
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"arb --version")
    system bin/"arb", "--help"
  end
end
