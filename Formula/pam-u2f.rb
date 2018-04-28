class PamU2f < Formula
  desc "Provides an easy way to use U2F-compliant authenticators with PAM"
  homepage "https://developers.yubico.com/pam-u2f/"
  url "https://developers.yubico.com/pam-u2f/Releases/pam_u2f-1.0.6.tar.gz"
  sha256 "101409455aa3257c8bb0968508a90f7ae58166e8ccb1d097e5fe9b541259ed3a"
  head "https://github.com/Yubico/pam-u2f.git"

  bottle do
    cellar :any
    sha256 "c4f9be6aaa79689f404bb1f52ecdf2c8a578cb46aa25325d8e8650324b2300b3" => :high_sierra
    sha256 "3ecffa558bba79eab57d87c6fd036e3ce52e1673d21e6b511ebe3d3b557876dd" => :sierra
    sha256 "e7596c439c48e065b7d40bc82b8cb628f473c0a86bf595ddc87afbfcd963c4ba" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "asciidoc" => :build
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
