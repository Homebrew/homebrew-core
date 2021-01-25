class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.6/libsixel-1.8.6.tar.gz"
  sha256 "9f6dcaf40d250614ce0121b153949c327c46a958cfd2e47750d8788b7ed28e6a"

  bottle do
    cellar :any
    sha256 "b2963fe42a38cea1521ac653c7009f278bd4ed1931ea567380b860d62edef0b7" => :big_sur
    sha256 "7e366d97fff08d175c3da3380ec8ac35da1a8dcd5f3fccb002f6e1e5c783b5c5" => :arm64_big_sur
    sha256 "520fa6d77af3c6cc84fb84b1a5b8797bb6e44396b70ad7654eb3362d2174d0ab" => :catalina
    sha256 "716d90122f113bd1c6b2ad7e872a476923981b4c26830c94ca68724437e860b1" => :mojave
    sha256 "9e061ce67b22c8ad8760bccc7e954ee46852285bc078087712538e102ce8215c" => :high_sierra
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
