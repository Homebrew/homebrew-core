class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.2/libsixel-1.8.2.tar.gz"
  sha256 "c464d2a6fcf35e9e6bad1876729e853a8b9f6abfe97d9e3487c9bfac45cf2a5f"

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
