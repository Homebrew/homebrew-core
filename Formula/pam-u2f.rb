class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.0.8.tar.gz"
  sha256 "52a203a6fab6160e06c1369ff104afed62007ca3ffbb40c297352232fa975c99"
  head "https://github.com/Yubico/pam-u2f.git"

  bottle do
    cellar :any
    sha256 "bf854539fa332aaa19f524dec3603f1cdbdfccb714081147b0c6845a6a9cfe24" => :catalina
    sha256 "5284e43e79ed3e1031484265ef76eb5f02dfd4782de5752f336927feae235750" => :mojave
    sha256 "07e3f722d932e932de1af8e871940b90fe1340c1332274d1cbc6cceb2e981bda" => :high_sierra
    sha256 "aba234dff72d3e2c9f51484e294776ca51bc7e03fe390f80539aa5b3e759d1a1" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libu2f-host"
  depends_on "libu2f-server"

  def install
    system "autoreconf", "--install"

    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x --no-xmllint"
    system "./configure", "--prefix=#{prefix}", "--with-pam-dir=#{lib}/pam"
    system "make", "install"
  end

  def caveats; <<~EOS
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
