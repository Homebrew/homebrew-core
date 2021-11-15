class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.6/libsixel-1.8.6.tar.gz"
  sha256 "9f6dcaf40d250614ce0121b153949c327c46a958cfd2e47750d8788b7ed28e6a"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "80163296378ee5b0ccd87b51f414f7a328ce48383d550f7a5cec641219d0efed"
    sha256 cellar: :any,                 arm64_big_sur:  "7e366d97fff08d175c3da3380ec8ac35da1a8dcd5f3fccb002f6e1e5c783b5c5"
    sha256 cellar: :any,                 monterey:       "9f03af39f51c3632c365a2af1cd92fd96370dba4445731f7bdb943086237576f"
    sha256 cellar: :any,                 big_sur:        "b2963fe42a38cea1521ac653c7009f278bd4ed1931ea567380b860d62edef0b7"
    sha256 cellar: :any,                 catalina:       "520fa6d77af3c6cc84fb84b1a5b8797bb6e44396b70ad7654eb3362d2174d0ab"
    sha256 cellar: :any,                 mojave:         "716d90122f113bd1c6b2ad7e872a476923981b4c26830c94ca68724437e860b1"
    sha256 cellar: :any,                 high_sierra:    "9e061ce67b22c8ad8760bccc7e954ee46852285bc078087712538e102ce8215c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "753e5b3da8b5137258aaa7a2645caae3024ab6d41e8fe980642a2be114a5e965"
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
