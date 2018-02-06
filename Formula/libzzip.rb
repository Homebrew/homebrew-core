class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.68.tar.gz"
  sha256 "9460919b46592a225217cff067b1c0eb86002b32c54b4898f9c21401aaa11032"

  bottle do
    cellar :any
    sha256 "ccdbd2db5fc153ad6b0990539b5b6702c65f964971f9256887e508c0c291d86f" => :high_sierra
    sha256 "e041856e291f2b6731d586ef8deb08593f65fc2f859019ff54c248e6c960c608" => :sierra
    sha256 "08baf77479ed193c4d80d3f0b6ce1d2625987d31b72ce26faed321ac21f55740" => :el_capitan
    sha256 "58fd8baaaadd33339ece54c63dde70fd4147c6f0302e28b953c10e85700fbb47" => :yosemite
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
