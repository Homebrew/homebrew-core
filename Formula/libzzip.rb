class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://github.com/gdraheim/zziplib/archive/v0.13.66.tar.gz"
  sha256 "59b18c7c4ed348ba8d63fa7e194e6b012cd94197265b7a7b3afb539d8206bd7d"

  bottle do
    cellar :any
    rebuild 3
    sha256 "301d6dd1b0d24f8aaccfbd3737bbf51d6c477af59c2d06838acfe6faa1921189" => :sierra
    sha256 "661b7f130316bfd82f6781652820198afecc0b92b5f9d92d6028ea866252e761" => :el_capitan
    sha256 "648e60acdbbe15d1abfccbdb8e34656cea044036eddbcc61e081eee9ccac245b" => :yosemite
    sha256 "6356e30f6be759bdb0234b811ef83069d36fdef29f5f3cf618a9547773672918" => :mavericks
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
