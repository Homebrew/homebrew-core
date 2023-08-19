class Libxcursor < Formula
  desc "X.Org: X Window System Cursor management library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcursor-1.2.1.tar.xz"
  sha256 "46c143731610bafd2070159a844571b287ac26192537d047a39df06155492104"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae05b72658d10621a2a0c6e21ffddc7324e1e32951d40cad613a1f083bbc37b0"
    sha256 cellar: :any,                 arm64_monterey: "74a824dd9c8862745f66a17707ae3e5b4dd0e4f144717af8c6b706b76bed01a9"
    sha256 cellar: :any,                 arm64_big_sur:  "e808a3694e529e169a6765b123c76b9e50e99bd781ee3fb5dc99370f2c97bff5"
    sha256 cellar: :any,                 ventura:        "f73f30a2edac35df26e71b2995064c6647272ed9ab801be52a789ffef6589787"
    sha256 cellar: :any,                 monterey:       "1ee235ee41180ae71b83c66948d3414ffaa855f689615dd3a247a68871dece6b"
    sha256 cellar: :any,                 big_sur:        "33c6a96d769a95b515172c9fabfeb7cf37b3f1ba40bac913dee1457ee0659cb2"
    sha256 cellar: :any,                 catalina:       "2c2cb1a2d43f836c277bdb33e4ebea581b49f84ef968c4d2c08e87bd9ffedc45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5feaf269b3a872f4a9b934baac4bfa833dba9e87437243d6071808b3b66495ea"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxfixes"
  depends_on "libxrender"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xcursor/Xcursor.h"

      int main(int argc, char* argv[]) {
        XcursorFileHeader header;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
