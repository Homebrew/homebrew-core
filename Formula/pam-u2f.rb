class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.0.8.tar.gz"
  sha256 "52a203a6fab6160e06c1369ff104afed62007ca3ffbb40c297352232fa975c99"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/pam-u2f.git"

  livecheck do
    url "https://developers.yubico.com/pam-u2f/Releases/"
    regex(/href=.*?pam_u2f[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "879e5ac58f8b3dbf4eed7fb075cee4683fae3e9a121000539eb810146c87f0d6" => :catalina
    sha256 "7967b151cd1ca9c32c61515c0921ec1bc265ae3a5f6a9681c342872974c139b7" => :mojave
    sha256 "82c61c7cc3d348e81b3669e3d3c1832ac7b97e34840a46f28a213c9052ad1df5" => :high_sierra
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
