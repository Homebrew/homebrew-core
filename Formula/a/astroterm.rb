class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "144ad050a4ca3840d321bb0e454cefbfee78f2b85a2e5add154ef4c49e984d86"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "http://tdc-www.harvard.edu/catalogs/BSC5", using: :nounzip
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    resource("bsc5").stage do
      (buildpath/"data").install "BSC5"
      mv buildpath/"data/BSC5", buildpath/"data/bsc5" if OS.linux?
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # astroterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/astroterm --version")
  end
end
