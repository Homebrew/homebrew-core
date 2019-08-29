class Osslsigncode < Formula
  desc "Authenticode signing of PE(EXE/SYS/DLL/etc), CAB and MSI files"
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "83deaed9d81ecacfdf2674b63eb090fd4781a46bdd92d97b911ab88e0eb97ec1" => :mojave
    sha256 "2106c87e481d094c2151b5da4152aea665114fda9233c1a09f437bed53ac2374" => :high_sierra
    sha256 "141c40e42eb70da814daa2bb893e31c7158f74f99cdf607dcba62426aa049a5a" => :sierra
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
