class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.18.2.tar.gz"
  sha256 "0f33b2d91c8f06713e1fcb99658372dc0357cbebe99e7c1850b68a927b7e54db"

  bottle do
    sha256 "e1f82a19bed0d0c8f6a218b24eccb4ccae2ae391d2946407b48b7e862a48ac6a" => :sierra
    sha256 "e001b38cfa8690744e83e75d28b2d3404ab09e0e8698ff1948fd371f6b42e843" => :el_capitan
    sha256 "04e632b298df57bdc1f9a41794fc55a92bcc417aefc0a3cca840c2a9c6736961" => :yosemite
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
    # NOTE:
    # To future maintainers: if you ever want to build this library as a
    # universal binary, see William Kyngesburye's notes:
    #     http://www.kyngchaos.com/macosx/build/dap

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
