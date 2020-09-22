class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.1.0.tar.gz"
  sha256 "0dc3bf96ebb69c6e398b5f8991493b37a8ce1af792948af71e694f695d5edc05"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/pam-u2f.git"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "5232a721233849c26ea3233f9328eec1df3de4fc3a3c144c2ae1698e815ab702" => :catalina
    sha256 "d17890b3639487004b5ca0b9596fb1ce73b4638ecff1595f5b6c5283eb8034b8" => :mojave
    sha256 "1a7fabe83bb36b06b7d1c95d9b22149d572f71be648b0482617225cc08917a17" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"
  depends_on "libu2f-host"
  depends_on "libu2f-server"

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
