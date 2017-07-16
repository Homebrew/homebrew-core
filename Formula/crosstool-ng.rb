class CrosstoolNg < Formula

  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz"
  sha256 "68a43ea98ccf9cb345cb6eec494a497b224fee24c882e8c14c6713afbbe79196"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2342870cc18491835bf49be8cb41f0af89c5e16a3835a4ca555b8f6e66461908" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "help2man" => :build
  depends_on "xz" => :build
  depends_on "coreutils"
  depends_on "wget"
  depends_on "gnu-sed"
  depends_on "gawk"
  depends_on "binutils"
  depends_on "libelf"
  depends_on "grep"
  depends_on "make"

  def install

    ENV.append "MAKE", "gmake"
    ENV.append "OBJDUMP", "gobjdump"
    ENV.append "READELF", "greadelf"
    ENV.append "LIBTOOL", "glibtool"
    ENV.append "LIBTOOLIZE", "glibtoolize"
    ENV.append "OBJCOPY", "gobjcopy"
    ENV.append "GREP", "ggrep"
    ENV.append "INSTALL", "ginstall"

    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
    ]

    system "./configure", *args

    # Must be done in two steps
    system "make"
    system "make", "install"

  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
  
end
