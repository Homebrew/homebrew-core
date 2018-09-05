class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://github.com/gdraheim/zziplib"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.69.tar.gz"
  sha256 "846246d7cdeee405d8d21e2922c6e97f55f24ecbe3b6dcf5778073a88f120544"

  bottle do
    cellar :any
    sha256 "e881e410df23c25784b37ca6c9a2a3b440a7592a239db29826f82b8dd530cc77" => :mojave
    sha256 "51a753ced0f53de1cf59412783261620f8238eb2a5aa2de9db4e1970a7fdabc6" => :high_sierra
    sha256 "dde8ad2f566db63cddc63cead06e776c3d91f71a00c28a6f3813f75ba5b6c102" => :sierra
    sha256 "0cd5457528cadfb83a31b83b16e16089816f991c290cfbe5446372a3291c676c" => :el_capitan
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
