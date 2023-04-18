class Libretls < Formula
  desc "Libtls for OpenSSL"
  homepage "https://git.causal.agency/libretls/about/"
  url "https://causal.agency/libretls/libretls-3.7.0.tar.gz"
  sha256 "9aa5d3a9133932c362075259b0b17bb0c89741fa1b2535136df2ded7a0c13392"
  license "ISC"

  livecheck do
    url "https://causal.agency/libretls/"
    regex(/href=.*?libretls[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab24d0f764f2aea1a992140e9174dfb5552ff89c66bddac4c8563789fc2ee912"
    sha256 cellar: :any,                 arm64_monterey: "7473b1360f8b615122d63ff2dcc7044f32539ce16e2c10fb68d4ef6b031aa5df"
    sha256 cellar: :any,                 arm64_big_sur:  "161c0f5432cca86208fbdd6424aa4ddd490ea6daf06d6bbec417355d990f36c6"
    sha256 cellar: :any,                 ventura:        "e913448b1f0e4087794005dbc156c4a0141565de582a23d858a9eb1fb0ff119d"
    sha256 cellar: :any,                 monterey:       "c54166938e317018bc97972606f734c6e68003e795a3cba2884d1f807960b69d"
    sha256 cellar: :any,                 big_sur:        "2d5355931bf0a0a7b474bb71d651f8152b6e0a200d5251cb2001c7e150e49cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c4a472f80be5e4b0b1d73297ced9cca7c4cf30a25b3842d777dfd42e482cf84"
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
