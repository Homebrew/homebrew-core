class Osslsigncode < Formula
  desc "Authenticode signing of PE(EXE/SYS/DLL/etc), CAB and MSI files"
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ce350145e5e0d0b3dc19042ccca189ec124519a4c5b5cd67319d7f1d517e1a1e" => :mojave
    sha256 "987a7f92ca9d86ecc687e6cdb7758a1c87db8d15e0307c9f6ad3c392ccc63f4b" => :high_sierra
    sha256 "1fcfa6be97026cd27145c79289c10c19ab123bd50ff682ed57236475368dd5cb" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/osslsigncode/osslsigncode.git"
    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
