class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.2/libsixel-1.8.2.tar.gz"
  sha256 "c464d2a6fcf35e9e6bad1876729e853a8b9f6abfe97d9e3487c9bfac45cf2a5f"

  bottle do
    cellar :any
    sha256 "91a56eaeeb48be9347ed3ef0618d0c89c1e966b2ae88be40c6b40d70c6b5504b" => :catalina
    sha256 "d4cb5ca4c127d45f7727dc0c8c4e527f537484f437922ed9fac74c5f628543f1" => :mojave
    sha256 "0e6e7c7fea1d75cd9fbbb3ef1e67f9c2d9daeff592808d2392a8e517f555536b" => :high_sierra
    sha256 "0847829121008f75c987d932ef91866d4d201fabe6533953a476f17be2379714" => :sierra
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
