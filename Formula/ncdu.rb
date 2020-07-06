class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.15.1.tar.gz"
  sha256 "b02ddc4dbf1db139cc6fbbe2f54a282770380f0ca5c17089855eab52a9ea3fb0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "994f7f4e9624a0984ec7c37b5b15b9ae5c24663ebffaba19b0979f4e99919fee" => :catalina
    sha256 "f7908eaf47c7842b15e56e17279583f4c938a9c920e1bae41f05d3e5506a99fb" => :mojave
    sha256 "d094385dbfd71831c5f2b03f0817a06df9471a44f5437aaf577676d2723bc865" => :high_sierra
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
