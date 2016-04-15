class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.6.0/fwup-0.6.0.tar.gz"
  sha256 "11d8d3a6e7464584b89d88571ee2d2dc1da758fe98525191e77982c60f35bcf3"
  revision 1

  bottle do
    cellar :any
    sha256 "8cf719c1fcc597773f3ba9cba9275af1a36af3e2c5111456f2d19755ee7fbf14" => :el_capitan
    sha256 "98be975a405d85ca7555151656cce1019eeae5ee653f7061ed424f8cb68cf40d" => :yosemite
    sha256 "733e83b973d626ff99d047d0d8e25dbb026d07d70e460842de47f115cf014839" => :mavericks
  end

  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/fwup", "-g"
    assert File.exist?("fwup-key.priv")
    assert File.exist?("fwup-key.pub")
  end
end
