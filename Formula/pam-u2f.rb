class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.3.0.tar.gz"
  sha256 "72360c6875485eb4df409da8f8f52b17893f05e4d998529c238814480e115220"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08d5272e545eb1fc86967363057ef008685ce1a34b704b10d2006c4edacca774"
    sha256 cellar: :any,                 arm64_monterey: "539a1e0ef3705c964b3946f1ddca73e9f834eb5656753d15066e9d68dc44d78f"
    sha256 cellar: :any,                 arm64_big_sur:  "6ccac9b5556ad25d997c0799e8e1e799d47dd0e3b9c2484cf3fea92e6bfb2475"
    sha256 cellar: :any,                 ventura:        "bf542f0d79daa165a64a01189c9756ce19414409d7f17a9b2123e44b284dbb3e"
    sha256 cellar: :any,                 monterey:       "be90e18ce3777c55e242903b4cc7bfae2d0a992061f627d87686c88a77f67f9c"
    sha256 cellar: :any,                 big_sur:        "320adb231803477099263432f31a30c32191daaddb208fd4491e8c12e1cddddf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3a86141ac2cd53b924b18732abb7a97c55892c537928667c05fba133d1f549"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--install"

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
    system "#{bin}/pamu2fcfg", "--version"
  end
end
