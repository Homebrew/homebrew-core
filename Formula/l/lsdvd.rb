class Lsdvd < Formula
  desc "Read the content info of a DVD"
  homepage "https://sourceforge.net/projects/lsdvd/"
  url "https://downloads.sourceforge.net/project/lsdvd/lsdvd/lsdvd-0.17.tar.gz"
  sha256 "7d2c5bd964acd266b99a61d9054ea64e01204e8e3e1a107abe41b1274969e488"
  license "GPL-2.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f9de3cf67cf812897d4afa2c329e1d9677a3f86977c4d8f359b9a2c259da2ca4"
    sha256 cellar: :any,                 arm64_sonoma:   "f1cd3a4917d6825315999218d37b76414eef62bf994f959250f0f95ca97d4659"
    sha256 cellar: :any,                 arm64_ventura:  "ba757936a28fde65072032578477812044621f4f8f73d9b9919c547ea902b402"
    sha256 cellar: :any,                 arm64_monterey: "0d71d460c8eaa5c01899c164df92f07d04648ca2807511be675cd08b161dbba5"
    sha256 cellar: :any,                 arm64_big_sur:  "d581725cf2628d8c123d3f6f54d1baf06cb33362d9f6dc7d033a4f7768729474"
    sha256 cellar: :any,                 sonoma:         "3520dc9651fd11c1f553b91e0c4ddd6665c9cb3a6ca5b6cbe331b372d708a4b6"
    sha256 cellar: :any,                 ventura:        "c1cad4dfbf96e83e2112dfabc98bff8b7482e3dfd79bd9a93286dc27436ac790"
    sha256 cellar: :any,                 monterey:       "5268aec2b5e5e3c89840661870ac95821c77aef6bfbe38447355402fae4b86f3"
    sha256 cellar: :any,                 big_sur:        "0d5d1a272ba88ff70ce68ddc35fca9811e2ca5222696373aaf3d2ffc0126a471"
    sha256 cellar: :any,                 catalina:       "986e89fe0980a78d7d7ef18fd646d3176edbaa7fd6531c38f698d3bdf2aed5dd"
    sha256 cellar: :any,                 mojave:         "66cbfc0e273fc63813c4948638ab849357ef9d3f72ce5b6322a27f5f614507f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd9145daad69de5b544d8e9824b42829c74b048322044a35b76bd9b2b355f1eb"
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdcss"
  depends_on "libdvdread"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"lsdvd", "--help"
  end
end
