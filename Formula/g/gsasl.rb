class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-2.2.1.tar.gz"
  sha256 "d45b562e13bd13b9fc20b372f4b53269740cf6279f836f09ce11b9d32bcee075"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "f101f94bb553856010b49dac82e42362cbf8cfb8d2934db50360418c77cac450"
    sha256 arm64_sonoma:   "08a3d6b5d9118239db46ac525dc8ff6dfcdb751aaf71c26d563e248ffe321601"
    sha256 arm64_ventura:  "e41f99e5a461ff905df7786838db28b8cf714a69e64d97074ac4d60192f1931e"
    sha256 arm64_monterey: "c99076a61434cfb716df47fe5ed29ce21765456effdd0eafbf7b645cff4fe85a"
    sha256 sonoma:         "f6d6007e35934b3f04c5cad57ff43d0ebe402c4de6fcb11be613607b6daf2c10"
    sha256 ventura:        "5889ccd75161e8bd226dfc1fa2cd9c3fcd0db7a70e1ca517037494246fc948a5"
    sha256 monterey:       "dc572d0c68f75916659bdc4fb41857dc956cacd060b78392a3e6ed83a84df623"
    sha256 x86_64_linux:   "d240c5d2c14596f6ea5db8bfbc926e5e970a7c123698b6522a2be5740bef5c1d"
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
