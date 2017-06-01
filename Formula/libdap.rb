class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.19.0.tar.gz"
  sha256 "59c384c2da01104a4ef37f010f3bcf5d46e85e30fcfc942c9181e17128f168a5"

  bottle do
    sha256 "4ec4781108986332b022cb81d238345f4e697e62ad5a3cc5cb66b77ee7d7ebe8" => :sierra
    sha256 "1e6bb8cf800083b6c5f6ae3f3efa1284bf436b16601ffaaa77214711aac0cccd" => :el_capitan
    sha256 "9ab1a73227319d216efd1c0f2737d2f1d43701f1fafbc375bb1963c631c047f2" => :yosemite
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-test", "Skip build-time tests (Not recommended)"

  depends_on "pkg-config" => :build
  depends_on "bison" => :build
  depends_on "libxml2"
  depends_on "openssl"

  needs :cxx11 if MacOS.version < :mavericks

  def install
    # Otherwise, "make check" fails
    ENV.cxx11 if MacOS.version < :mavericks

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    # Let's try removing this for OS X > 10.6; old note follows:
    # __Always pass the curl prefix!__
    # Otherwise, configure will fall back to pkg-config and on Leopard
    # and Snow Leopard, the libcurl.pc file that ships with the system
    # is seriously broken---too many arch flags. This will be carried
    # over to `dap-config` and from there the contamination will spread.
    args << "--with-curl=/usr" if MacOS.version <= :snow_leopard

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
