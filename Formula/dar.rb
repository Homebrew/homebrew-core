class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.4.22/dar-2.4.22.tar.gz"
  sha256 "19a977e3ca7ed15e4406bb3e08ff2b8225d291a5c4189a6d5b7b3d75eea50f2b"

  bottle do
    sha256 "7ce41e06f2f8a0d4dd65a52904250c6cd7f44223b3c438931646c4ad2ff6f97c" => :sierra
    sha256 "502782415aee418c5a81f16e2635b618c88108a642240c94117d041bed2a1c6c" => :el_capitan
    sha256 "7e672a55def541a9dd43b6915aca0ca2cc3d5e5fdcce55e77274caca98eb5f59" => :yosemite
    sha256 "a74696553c86f94dfd1ebdad29ad9c5d22c79d78fc023e43bb86f272fbfc4d87" => :mavericks
  end

  option "with-docs", "build programming documentation (in particular libdar API documentation) and html man page"
  option "with-libgcrypt", "enable strong encryption support"
  option "with-lzo", "enable lzo compression support"
  option "with-upx", "make executables compressed at installation time"

  if build.with? "docs"
    depends_on "coreutils" => :build
    depends_on "doxygen" => :build
  end

  depends_on "gettext" => :optional
  depends_on "gnu-sed" => :build
  depends_on "libgcrypt" => :optional
  depends_on "lzo" => :optional
  depends_on "upx" => [:build, :optional]

  def install
    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"
    ENV.prepend_path "PATH", "#{Formula["coreutils"].opt_libexec}/gnubin" if build.with? "docs"
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-dar-static
      --prefix=#{prefix}
    ]

    args << "--disable-build-html" if build.without? "docs"
    args << "--disable-libgcrypt-linking" if build.without? "libgcrypt"
    args << "--disable-liblzo2-linking" if build.without? "lzo"
    args << "--disable-upx" if build.without? "upx"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
