class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/guile/guile-2.0.11.tar.xz"
  mirror "https://ftp.gnu.org/pub/gnu/guile/guile-2.0.11.tar.xz"
  sha256 "aed0a4a6db4e310cbdfeb3613fa6f86fddc91ef624c1e3f8937a6304c69103e2"
  revision 3

  bottle do
    sha256 "aac47f5f0bf1cdc6f8295a9be012b45421cada0ffde8348af6b0b7641c0f41d9" => :sierra
    sha256 "88dadf188dc21ced701f1b8881eaa73484173547a19f934fd3ad30f822c9c77a" => :el_capitan
    sha256 "f126e6c0598ab40f3bbe8c4eca2edcef34084095c713e697d9481b8bc2260b13" => :yosemite
    sha256 "a4bb93e6d150148a77d4ae4b5239e946d20363278fbefba21f47d3c05c70c453" => :mavericks
  end

  devel do
    url "http://git.savannah.gnu.org/r/guile.git",
        :tag => "v2.1.2",
        :revision => "d236022eb0d285af3d462de9e99a212eba459df2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  head do
    url "http://git.sv.gnu.org/r/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :run # guile-config is a wrapper around pkg-config.
  depends_on "libtool" => :run
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  fails_with :llvm do
    build 2336
    cause "Segfaults during compilation"
  end

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=23870
  # https://github.com/Homebrew/homebrew-core/issues/1957#issuecomment-229347476
  if MacOS.version >= :sierra
    patch do
      url "https://gist.githubusercontent.com/rahulg/baa500e84136f0965e9ade2fb36b90ba/raw/4f1081838972ac9621fc68bb571daaf99fc0c045/libguile-stime-sierra.patch"
      sha256 "ff38aa01fe2447bc74ccb6297d2832d0a224ceeb8f00e3a1ca68446d6b1d0f6e"
    end
  end

  def install
    system "./autogen.sh" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on OS X --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<-EOS.undent
    (display "Hello World")
    (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
