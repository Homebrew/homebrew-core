class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.5/libsixel-1.8.5.tar.gz"
  sha256 "74e7d2b53c4364ccb3afb8d00dafd4061f7b9a65edd3fdb330647d8294400e59"

  bottle do
    cellar :any
    sha256 "d43f66810d1c75968b51fd99578882b10fa759c9d9f02379ff2dfd400adf02b0" => :catalina
    sha256 "99eba79e3705955854ec6586bb2b8aa5708e2f58672c2e9168074cf90cb9b45d" => :mojave
    sha256 "90db47e866f4ce33685cec28abdb1dcafba4354cbc294f8a4109182833ba29d8" => :high_sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-jpeg=#{Formula["jpeg"].prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    system "#{bin}/img2sixel", fixture
  end
end
