class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    cellar :any
    rebuild 3
    sha256 "f133f438e1833bff0f5cf43109e27768a983a068dec90a767ba9027d2bc2f0b9" => :catalina
    sha256 "6c5f143bb202c280c3b3e340a420a1cf6c6d936cba70faf837cd215e451987fe" => :mojave
    sha256 "6b8b5f7801a6cf31ecd5ac82ee02ca344f9634ad01c235a828e3875d0354931b" => :high_sierra
  end

  depends_on "libtool"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-fortran",
                          "--disable-fortran95",
                          "--disable-php",
                          "--disable-python",
                          "--without-liblzma",
                          "--without-libzzip"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
