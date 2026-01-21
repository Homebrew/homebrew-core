class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "6d9d61b818b01bd951d5340f09486bdc66aa107259acf78dfa8c3f875a36ea1f"
  license "MIT"
  revision 1
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b96bb83bb335486ec6ca0fbae19a71c86d13c43a74aa249e9c06440825d42732"
    sha256 cellar: :any,                 arm64_sequoia: "ab43710f896fd0e1774bc3d5f61a39f91938a18da5bf352e54b86e989e759ec9"
    sha256 cellar: :any,                 arm64_sonoma:  "93e425799689e9205f5c33ede3bfe2f6df9f60bcdf4f090f870691eb784aa068"
    sha256 cellar: :any,                 sonoma:        "39ba609a32145bcaa97c553cd1862019720b5020ded6c4ac26aed6183c5dfb34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0980a46121da8061234713a8d5d233273eff08a1257477f609d89adf4e3fe038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4dbe1cb9db8ebd6096aa44e5d5364583d111564b8fdec8ca8c4990cfb5775b0"
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
