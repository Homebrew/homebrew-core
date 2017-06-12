class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.67.tar.gz"
  sha256 "1278178bdabac832da6bbf161033d890d335a2e38493c5af553ff5ce7b9b0220"

  bottle do
    cellar :any
    sha256 "d52566bf4fdde138bcc5100df2cd637a3fe06838f359d8f7a287d4ca194867d0" => :sierra
    sha256 "695803033aa85df08b1690909f6f0efa3ba7cbcf12c63246087ecc6c485d5f4b" => :el_capitan
    sha256 "5f7745b6c8452a8264d9cb08bdff10949244d171ceeb9968a2e6c299b787dfe9" => :yosemite
  end

  option "with-sdl", "Enable SDL usage and create SDL_rwops_zzip.pc"

  deprecated_option "sdl" => "with-sdl"

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "sdl" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-sdl" if build.with? "sdl"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
