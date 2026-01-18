class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "6d9d61b818b01bd951d5340f09486bdc66aa107259acf78dfa8c3f875a36ea1f"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f0ff05dcecdc0944f4045f3b1cf594bdf7149db7aa065bd98c7ee9ef362ddf7"
    sha256 cellar: :any,                 arm64_sequoia: "cf9275621d4798eed54c0868642318c99d98861d2e908345a92abc5fa0d9a106"
    sha256 cellar: :any,                 arm64_sonoma:  "09a8f21cfa607a1939ac6a2c02a228195a3a9fafe797a24edde1105e5ea1480d"
    sha256 cellar: :any,                 sonoma:        "0a6cdc47c6fd7d61e5a0d1a5719fd774a0bd8ab3270ac50d9f0c0f1f7926b612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "902def22bd133694b3b93047ebc186975b957ee005188e6e786350a33372b722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433fccc43feab752ae53de01b02d12930c1ce0e97f4d2efcab5e8d3d136c43ee"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "argtable3"

  uses_from_macos "vim" => :build # for xxd
  uses_from_macos "ncurses"

  resource "bsc5" do
    url "https://distfiles.alpinelinux.org/distfiles/edge/astroterm-bsc5-20231007", using: :nounzip
    mirror "http://tdc-www.harvard.edu/catalogs/BSC5"
    sha256 "e471d02eaf4eecb61c12f879a1cb6432ba9d7b68a9a8c5654a1eb42a0c8cc340"
  end

  def install
    # `mirror` has a different filename, but Homebrew always uses the primary URL's filename
    resource("bsc5").stage do
      (buildpath/"data").install "astroterm-bsc5-20231007" => "bsc5"
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
