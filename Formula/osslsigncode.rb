class Osslsigncode < Formula
  desc "Authenticode signing of PE(EXE/SYS/DLL/etc), CAB and MSI files"
  homepage "https://sourceforge.net/projects/osslsigncode/"
  url "https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz"
  sha256 "f9a8cdb38b9c309326764ebc937cba1523a3a751a7ab05df3ecc99d18ae466c9"

  bottle do
    cellar :any
    sha256 "54f30bcedde90a5186e31cde5585e1a4ed16391ef77ca903a05350896732ef16" => :mojave
    sha256 "4e079298b889a8ff8b629bc97323852b7f9e342de55ab74e601c995e6ad585f1" => :high_sierra
    sha256 "898333a70f9700c159c8a29b7452c210f61004b23f39b0637131f7257f9250ec" => :sierra
    sha256 "ed69f3ff0b8144a10a66cbe0a1986717a5564415768530110ae66749777f3490" => :el_capitan
    sha256 "5f3799537630936f8d7954e9ec28f191fff6e1713f6b209aa94b2b665e5eaf88" => :yosemite
    sha256 "59da5261972c8d26f0238c6ea42f5b247489d41e7ce6525c703675a22e260cfa" => :mavericks
    sha256 "49a6dd76e78c82062041e5025ed1e7d71f1c53b51ef0e314a5e6938a07b6e49d" => :mountain_lion
  end

  head do
    url "https://git.code.sf.net/p/osslsigncode/osslsigncode.git"
    depends_on "automake" => :build
  end

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

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
