class Oggz < Formula
  desc "Command-line tool for manipulating Ogg files"
  homepage "https://www.xiph.org/oggz/"
  url "http://downloads.xiph.org/releases/liboggz/liboggz-1.1.1.tar.gz"
  sha256 "6bafadb1e0a9ae4ac83304f38621a5621b8e8e32927889e65a98706d213d415a"

  bottle do
    cellar :any
    sha256 "a0fad22ba18930be45c7226f2db0fe8b39c988c84c392807ddc75e2d40b3a9ad" => :sierra
    sha256 "4c1819dbc134981faf5e2e03dc69d210deb8dabd59b71969c1f479fa32322635" => :el_capitan
    sha256 "c6076111f111c5d77dc608bcb4892f10dffb84e5b4f5ebdfba311ec332fa6623" => :yosemite
    sha256 "a3aa5e741dd3e7a9aebb65748f80f45947549a79915b68161a79f12cb37b4b12" => :mavericks
    sha256 "41d7d2c9b6ab027579d2040579441973cc0301d6103b71d52441e02993ea3198" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/oggz", "known-codecs"
  end
end
