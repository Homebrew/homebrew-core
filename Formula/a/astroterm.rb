class Astroterm < Formula
  desc "Planetarium for your terminal"
  homepage "https://github.com/da-luce/astroterm"
  url "https://github.com/da-luce/astroterm/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "10a98255a46517ee306be73f156eb78163aff8801f46b84a731f7b5913e1d6f5"
  license "MIT"
  head "https://github.com/da-luce/astroterm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "366ef8ecc45c6c188f134156cc8562a4e3ce17934e4406c236969482281cace6"
    sha256 cellar: :any,                 arm64_sequoia: "e5b2c209d0b5739bad1537dca88864d25d57002942479efe45dea9ea8cd583a0"
    sha256 cellar: :any,                 arm64_sonoma:  "42d0e0707dd6b913caae181ef0e222aef47ab0611b4fa545bdc6bc0bc54b89bd"
    sha256 cellar: :any,                 sonoma:        "074aa01bc5d23274961b4888bcc190bb78ca79c832a9878781bda9352c7a79d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68071e5791586bac8984694f2420d4661ca5deea2629d2a18d8a40b5f8b0879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d68d0ddf78f5fa237ff63291c797fddc3b87f5fd1aba16392fc5e52e5a8ff9c"
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
