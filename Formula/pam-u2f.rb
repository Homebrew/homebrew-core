class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.2.1.tar.gz"
  sha256 "70e741bca197b64b4fbe8dd1f6d57ce2b8ad58ca786352c525f3f2d44125894c"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/pam-u2f.git", branch: "master"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "476791759bc89c2d77b81e3f0f17721a4a5ca895a34355620e14f8e33812cc97"
    sha256 cellar: :any,                 arm64_big_sur:  "4677220bea1fa2a9f34eb65c21dfca4baa44545170dad22f19f1fe100becaaa7"
    sha256 cellar: :any,                 monterey:       "cbbc6d33d08ecfd7f14b9630643fce1434eeb7b83278e2b7c6fba8cca1ebe346"
    sha256 cellar: :any,                 big_sur:        "12aad373888f146f549662f95254fa01fdcc29e625b766e1f24d8c371f0dfa96"
    sha256 cellar: :any,                 catalina:       "5b4bbecdd81cc0754107b618b06bc28f8e72875228aa1fb399b10ce7a125fc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d628932292483684948a099679fcef0f33b31cadbeeeb907c47fd217bb8d46a6"
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
