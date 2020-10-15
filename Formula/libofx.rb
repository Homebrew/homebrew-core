class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.15.tar.gz"
  sha256 "e95c14e09fc37b331af3ef4ef7bea29eb8564a06982959fbd4bca7e331816144"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libofx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "aa4c73d9fe09d54bc4fb0a1dde14bd927949f4d0ce100dae987f03df79236958" => :catalina
    sha256 "9b731e873dee237f2723fd05aa7f88b0e64f29197297c33e9def68112d7c2fc8" => :mojave
    sha256 "7c561c3c928ad133d1763afe6a9d25b784d236411f00085151740f3505b164b3" => :high_sierra
  end

  depends_on "open-sp"

  def install
    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
