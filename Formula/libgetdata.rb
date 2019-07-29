class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    rebuild 2
    sha256 "fa65dd52dae9d73aeaa6fdf33edb9c589b537c7aa8dde1bc07ba62ecf5718370" => :mojave
    sha256 "13e9d36f7ee8156ad9b5ffaa646588084e9212238aafbab50849f60c6cad0ab9" => :high_sierra
    sha256 "9a96ebcf2d456594b5205c2ff0918dc7bcfff29be358fd6e369131f941e02f75" => :sierra
    sha256 "88055dcabc5ed8b6cc068e244f8174eb798fd778e67a27867b3a0b33b3453121" => :el_capitan
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
