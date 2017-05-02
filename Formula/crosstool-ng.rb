class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.22.0.tar.xz"
  sha256 "a8b50ddb6e651c3eec990de54bd191f7b8eb88cd4f88be9338f7ae01639b3fba"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3ada31fa193f947f2145794eb2b24f12b0d27106c707685f0e92678ac180d9e0" => :sierra
    sha256 "1563e4b907a4e290d0b3b4e9c0bbfb840f42eb90b2c1a10c7a6632560d59dd9e" => :el_capitan
    sha256 "a1a7a286d87ff625b6e5910f962e0248ddd610dcf91ddd3b8923bf4f7476a23d" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "help2man" => :build
  depends_on "coreutils"
  depends_on "wget"
  depends_on "gnu-sed"
  depends_on "gawk"
  depends_on "binutils"
  depends_on "libelf"
  depends_on "grep" => :optional
  depends_on "homebrew/dupes/make" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --with-objcopy=gobjcopy
      --with-objdump=gobjdump
      --with-readelf=greadelf
      --with-libtool=glibtool
      --with-libtoolize=glibtoolize
      --with-install=ginstall
      --with-sed=gsed
      --with-awk=gawk
    ]

    args << "--with-grep=ggrep" if build.with? "grep"
    args << "--with-make=#{Formula["make"].opt_bin}/gmake" if build.with? "make"
    args << "CFLAGS=-std=gnu89"

    system "./configure", *args

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to install a modern gcc compiler in order to use this tool.
    EOS
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
