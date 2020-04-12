class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.4.1.tar.xz"
  sha256 "46d34034f4c96d120e0639f87a26590427cc29e95fe5489e903a48ec96402ba3"

  bottle do
    cellar :any
    sha256 "3efd84a082f8a44a4a0e74c822e61df424b86904f63528cc0a5c193c9f0234ab" => :catalina
    sha256 "b0fd4cddd26d2d5ef3c5f6cdecabfa089beb528d5a084a57d89b757c7a753bd3" => :mojave
    sha256 "0bdb25c68953067f4eb814cadc6417c5af2ab83dc4c755d70380c215fa3a96ba" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 4, output.lines.count
  end
end
