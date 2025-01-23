class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.3.2.tar.gz"
  sha256 "38be7d1897271cb3fee391d2383b35afc126ad431a91a9de6e99108c12cc9490"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a159e34803506bcb44ff6c28db5879ac4ec11b706eddb6df55c956ee89dcae1"
    sha256 cellar: :any,                 arm64_sonoma:  "2bc91a296c14948e1a7fb9c61a5e6ba9d6e2d169bdc3f1955f4d7f4586d8bc71"
    sha256 cellar: :any,                 arm64_ventura: "406d09f9b431e7ac540d312dc0b1dc9f7a7db91e7abb5f23457a2f985b19576c"
    sha256 cellar: :any,                 sonoma:        "c5aa1b4f377072a8a821f9d711afceb700b0ba786581996efa2601c1906b39ae"
    sha256 cellar: :any,                 ventura:       "be59022d553d437078dbed6dfd29e39d693caf4ac8bff9cc9bb75063573c24ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68c9f977e803714c2c9cc19dba8716aa68b20a306e358e4d06666e91d0fbb3c9"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use a U2F key for PAM authentication, specify the full path to the
      module (#{opt_lib}/pam/pam_u2f.so) in a PAM
      configuration. You can find all PAM configurations in /etc/pam.d.

      For further installation instructions, please visit
      https://developers.yubico.com/pam-u2f/#installation.
    EOS
  end

  test do
    system bin/"pamu2fcfg", "--version"
  end
end
