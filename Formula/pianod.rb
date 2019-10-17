class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod/pianod-176.tar.gz"
  sha256 "4f3be12daef1adb3bcbbcf8ec529abf0ac018e03140be9c5b0f1203d6e1b9bf0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "14b7d55edd091ded3ad707d14e81136fdd34ec38308b292bd78a4879c7690fa1" => :catalina
    sha256 "e85267b08e38e5657066b8c20e84177ada48b11567c79de70e4b61b65da515f7" => :mojave
    sha256 "f3b3d4d7ab4c8841a87cb44ecfee33fdd69b05c85c2f62f094ae4251fe38d777" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "mad"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
