class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.4.0.tar.gz"
  sha256 "a59927cea38ea8d91a6836a04e20fc629edde4204b16082f703f6db378e9c634"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/pam-u2f.git", branch: "main"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eea123d3d2c8212bf6bf70731792ee7c847bbd873efc44a63469089248174f04"
    sha256 cellar: :any, arm64_tahoe:       "8681fdfdf88df793c747a37ed8fb6ec9e69783dd326eadeaa2d0110b7093eb61"
    sha256 cellar: :any, arm64_sequoia:     "4019cbc80857df4055c5edeb17d6b1b313612680e50043f8671e4463fe3d9b5f"
    sha256 cellar: :any, arm64_linux:       "b3acdc7c28c716fb68d4d8f78b42804f8bb8a0a080f0f2abbea67b1fbd888e35"
    sha256 cellar: :any, x86_64_linux:      "ac040cb58ee39e9a82ab24c96834d322593b5827d5251b7c6a7b80453ff31b39"
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  depends_on "openssl@4"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    ENV["A2X"] = "#{formula_opt_bin("asciidoc")}/a2x --no-xmllint"
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
