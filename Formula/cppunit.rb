class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "https://dev-www.libreoffice.org/src/cppunit-1.15.1.tar.gz"
  sha256 "89c5c6665337f56fd2db36bc3805a5619709d51fb136e51937072f63fcc717a7"

  bottle do
    cellar :any
    sha256 "6c68eac5da5330a2536097146f8d25b1443cec83d00c2ee05b1f1abc62eb0500" => :catalina
    sha256 "39db5ec22ab81000077b55383765d2f2bbc1b5080e4feb25494693af0ec7cec8" => :mojave
    sha256 "d1eb4e839796b944ed3b966cf6a71e7eff2498237cf4ca2ef38d60e114320e48" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DllPlugInTester", 2)
  end
end
