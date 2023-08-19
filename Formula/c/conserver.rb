class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.2.7/conserver-8.2.7.tar.gz"
  sha256 "0607f2147a4d384f1e677fbe4e6c68b66a3f015136b21bcf83ef9575985273d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8c85d9e24aeeb0f9e6ef4840f5927511db3179ad29fcccfc4643d8d17660402c"
    sha256 cellar: :any,                 arm64_monterey: "cbe78e9a34501f728a0815e9ccf11c3a149b6e16fd902339ccf1680cebefcebe"
    sha256 cellar: :any,                 arm64_big_sur:  "a01d04c6b9b777e20f96e1a05d32040d636b624c647f114c2093e04d117d11b3"
    sha256 cellar: :any,                 ventura:        "223d91506822b1d74d0bd1c0c8c2c4e7649ebe23d8ef2f5c431b76f84d7d975f"
    sha256 cellar: :any,                 monterey:       "3184c7059ff555f33cfe4e8c6b06c58266bd6cfd17991493ec1edd2f79436091"
    sha256 cellar: :any,                 big_sur:        "909d45ca31f883bc661141cb2fa173c2c218dd5cd9305ddb5737aac0081eb81d"
    sha256 cellar: :any,                 catalina:       "73e2f36eedeb506e1730c6b5b55eea95899f69232f52e86796964ad61e81e856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e543125304a0b15fb67371473346c48ebd27ce69377ce920ac8645f2f0cdea8"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
