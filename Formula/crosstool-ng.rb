class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.22.0.tar.xz"
  sha256 "a8b50ddb6e651c3eec990de54bd191f7b8eb88cd4f88be9338f7ae01639b3fba"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c683511e44e035d07be5a4573a9ffe9d9bf017a410a50020fa82127a4a6199f5" => :sierra
    sha256 "077bb9340db4895fd5e091921b198fc4b0f91467b3ab3071cbec2afc8f93b5fd" => :el_capitan
    sha256 "eb37c5ddab9d3984dcb735f33aa542c5f7cc23f7a65a1dfca867e57c1b4cb757" => :yosemite
    sha256 "2d40830719668c431957407f2b3a705fde28c4638f05a023765cfec5d4196d6c" => :mavericks
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
  depends_on "homebrew/dupes/grep" => :optional
  depends_on "homebrew/dupes/make" => :optional

  # Avoid superenv to prevent https://github.com/mxcl/homebrew/pull/10552#issuecomment-9736248
  env :std

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
    system "#{bin}/ct-ng", "version"
  end
end
