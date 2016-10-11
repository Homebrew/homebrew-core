class Libzzip < Formula
  desc "Library providing read access on ZIP-archives"
  homepage "https://sourceforge.net/projects/zziplib/"
  url "https://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.62/zziplib-0.13.62.tar.bz2"
  sha256 "a1b8033f1a1fd6385f4820b01ee32d8eca818409235d22caf5119e0078c7525b"

  bottle do
    cellar :any
    rebuild 3
    sha256 "301d6dd1b0d24f8aaccfbd3737bbf51d6c477af59c2d06838acfe6faa1921189" => :sierra
    sha256 "661b7f130316bfd82f6781652820198afecc0b92b5f9d92d6028ea866252e761" => :el_capitan
    sha256 "648e60acdbbe15d1abfccbdb8e34656cea044036eddbcc61e081eee9ccac245b" => :yosemite
    sha256 "6356e30f6be759bdb0234b811ef83069d36fdef29f5f3cf618a9547773672918" => :mavericks
  end

  option "with-sdl", "Enable SDL usage and create SDL_rwops_zzip.pc"
  option :universal

  deprecated_option "sdl" => "with-sdl"

  depends_on "pkg-config" => :build
  depends_on "sdl" => :optional

  def install
    if build.universal?
      ENV.universal_binary
      # See: https://sourceforge.net/p/zziplib/feature-requests/5/
      ENV["ac_cv_sizeof_long"] = "(LONG_BIT/8)"
    end

    args = %W[
      --without-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-sdl" if build.with? "sdl"
    system "./configure", *args
    system "make", "install"

    ENV.deparallelize # fails without this when a compressed file isn't ready
    system "make", "check" # runing this after install bypasses DYLD issues
  end

  test do
    (testpath/"README.txt").write("Hello World!")
    system "/usr/bin/zip", "test.zip", "README.txt"
    assert_equal "Hello World!", shell_output("#{bin}/zzcat test/README.txt")
  end
end
