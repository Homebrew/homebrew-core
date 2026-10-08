class Libretls < Formula
  desc "Libtls for OpenSSL"
  homepage "https://git.causal.agency/libretls/about/"
  url "https://causal.agency/libretls/libretls-3.8.1.tar.gz"
  sha256 "3bc9fc0e61827ee2f608e5e44993a8fda6d610b80a1e01a9c75610cc292997b5"
  license "ISC"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://causal.agency/libretls/"
    regex(/href=.*?libretls[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "185d10f52d0136d15f78cf10c7b3fcfd97b6d8b3824a84618ae511457a0aaf65"
    sha256 cellar: :any, arm64_tahoe:       "30eac04fd6815d88f826560f77a70c8ba5a79fc2717e36de76ffc8b1bc099645"
    sha256 cellar: :any, arm64_sequoia:     "72007080763359f16c0fcdf103b7e920141ad5bcf7ac528029563ebda2f2f8f9"
    sha256 cellar: :any, arm64_linux:       "2b796742e96dd23b1b2f783c147b1521afd803ff3c494e5b091257bbb2cafbef"
    sha256 cellar: :any, x86_64_linux:      "227011699330636cac1883c53446a65f8eed757649f78739093657ef6969e124"
  end

  depends_on "openssl@4"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tls.h>
      int main() {
        return tls_init();
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ltls"
    system "./test"
  end
end
