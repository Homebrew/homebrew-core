class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftpmirror.gnu.org/gnu/gsasl/gsasl-2.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.2.tar.gz"
  sha256 "41e8e442648eccaf6459d9ad93d4b18530b96c8eaf50e3f342532ef275eff3ba"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "1dd75fa56b2505c6edd733f8848a46dd624dba73d43df132deddc1a05c167d30"
    sha256 arm64_sequoia: "f7ec07e3b1add0e32af563452c3f8ebf2317b3acad6b6a48b029dd72491354ab"
    sha256 arm64_sonoma:  "be4ad77df9264e1dbcd61df831870348ef3f0f7033f59c201f60ca78b8f5b608"
    sha256 arm64_ventura: "9abcebd5e9da69094251b1d2de7434c3d97cc502bcf18406e5689bfb9ad166cc"
    sha256 sonoma:        "f8b9c8e586b6e83810512a0feb031b2b1a16f181c3c06b3a223ba7463dca256d"
    sha256 ventura:       "7915a31160f8bc10fe820d2e00e885d422af7b81d1c3b9f47c6c290083020635"
    sha256 arm64_linux:   "653c99b1e92e213c8f3d2a479bc24fa7db0b6d7a13e00110470f02b331412f92"
    sha256 x86_64_linux:  "e617b7fd6c52d487cdd7e33f6ade76b2fa98499605192cd1420c06fa5b3218ae"
  end

  depends_on "libgcrypt"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--with-gssapi-impl=mit", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
