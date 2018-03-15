class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.68.tar.gz"
  sha256 "9460919b46592a225217cff067b1c0eb86002b32c54b4898f9c21401aaa11032"

  bottle do
    cellar :any
    sha256 "6fc3839c488567323daa8737182140a338cbce6d5b136ed73668756efc457546" => :high_sierra
    sha256 "c37291e0ffc64c667465033428aba0c879d6f8864999d0471c763f9a370f1fa9" => :sierra
    sha256 "5bb830291d6647609a9eb78747a3b13de656f5cb2bf40c6a58688da986a58a2d" => :el_capitan
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
