class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/Devel/pianod2-241.tar.gz"
  sha256 "f274d2fbd07f43dd03deea5cb11c282639c6e33d675e0f616e8bb36788624b10"

  bottle do
    sha256 "9027233a185aad19ef50a5b2de2d94256015c3d781063d6a0587802a7b746a81" => :sierra
    sha256 "2ee0ba99862d32947b418b00ea3d1f6bab6bbbfbe5a9cd190558e3baf4c0586b" => :el_capitan
    sha256 "535664f3192932537dc9656380e44fa8c1e835ba361e6f92418cd379e6970d0d" => :yosemite
    sha256 "33d938cf80c04f224f72bca2592a20b28707246c5c5450baaf1974e4114e8bfc" => :mavericks
  end

  devel do
    url "https://deviousfish.com/Downloads/pianod2/Devel/pianod2-267.tar.gz"
    sha256 "64847b870f36f311a0725a7b52ee7641bb8e2bf4f57c42fdb19150e60bf36a9c"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => :build if build.devel?

  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "faad2" => :recommended
  depends_on "mad" => :recommended

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
