class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.19.1.tar.gz"
  sha256 "5215434bacf385ba3f7445494ce400a5ade3995533d8d38bb97fcef1478ad33e"

  bottle do
    sha256 "a227bd7d6af450edcbcbe552b16aea80dabaf319914b65f6adf03c2e0e57fc15" => :mojave
    sha256 "acb605289bb709760f85304a454047adc51bc7c62f789b1a6e994def60320707" => :high_sierra
    sha256 "643d28d3e211bbca74f1d3a11e3af23128e5da457551d695d6e23fd350bb673c" => :sierra
    sha256 "999d0a4e5235b9c646047e12ebf48c023f073f66ee7cc9952d2873242a66c8b7" => :el_capitan
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
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
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
