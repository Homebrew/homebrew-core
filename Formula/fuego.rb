class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 6
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 arm64_ventura:  "988e31adb6dd89fed085bd74db4c30d3609369485e1bbcc42517d8a19b207ec4"
    sha256 arm64_monterey: "7e261399d0fa9973908233ad77094b4688c7452aa04858c5193930e3e81b4ff0"
    sha256 arm64_big_sur:  "fcef8228e032d8e6be38d871a70fc5c4423e5f4ae5abcb18fa808d04f583dbba"
    sha256 ventura:        "54d2759466c9910a9efe18e805ae9c882bded7a7e4b64362899849a7b320479d"
    sha256 monterey:       "2e34366e4aba730a743d11c27dd6eb2aae7a6e17f8e920d23d59e146376b8199"
    sha256 big_sur:        "994e8d7d7bd8197538c7593730b23fbef1266fc5776b7041a44eb6d6174546dd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
