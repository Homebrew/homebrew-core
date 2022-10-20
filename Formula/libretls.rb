class Libretls < Formula
  desc "Libtls for OpenSSL"
  homepage "https://git.causal.agency/libretls/about/"
  url "https://causal.agency/libretls/libretls-3.5.2.tar.gz"
  sha256 "59ce9961cb1b1a2859cacb9863eeccc3bbeadf014840a1c61a0ac12ad31bcc9e"
  license "ISC"

  livecheck do
    url "https://causal.agency/libretls/"
    regex(/href=.*?libretls[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "00e8653e8a3e9cb237756b540dfc0bcc94b1f27067b4b9d02112e4ca1e8c57e2"
    sha256 cellar: :any,                 arm64_big_sur:  "bb69e5195aeefd21ec4dd827b714f9e0285f9efdc623c39fa83bf18a17e17d02"
    sha256 cellar: :any,                 monterey:       "489fb71ab2c232d4733f4bff4c55dc2c9e0673aaf63f75ca749b443d06e744eb"
    sha256 cellar: :any,                 big_sur:        "d499ae8fb0216c9ae2bcacb9a06878c43fca49d085a8bd7a9a72beeda189f34e"
    sha256 cellar: :any,                 catalina:       "5a9c93883b7e683bd6508a7851055cd46f8129ae77979a96105792a13753e54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ccfc7d70ef4d7ae9b55d18b01cdfa5dfe83455058eb3251effa767626306e06"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tls.h>
      int main() {
        return tls_init();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltls"
    system "./test"
  end
end
