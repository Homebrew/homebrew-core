class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "http://www.opendap.org"
  url "https://github.com/OPENDAP/libdap4/archive/version-3.18.0.tar.gz"
  sha256 "373c60cf2c5c9eaf598558167aedbc3ef9a0d9b652dfbd96b4725637cf03f628"
  head "https://github.com/OPENDAP/libdap4.git"

  bottle do
    sha256 "4c7e4ac48248b98e01434e58b0f4bd49430728494a79a14606c7dc7b36a1214a" => :el_capitan
    sha256 "1adc5a6e18823ac189ee748323f6e95160d098faa2ce0f2dec94dc08c9c0afc0" => :yosemite
    sha256 "cf167f219d06fe935453d1af606d8d38711c865f541d1f61007cb27f2666bae6" => :mavericks
  end

  option "without-test", "Skip build-time tests (Not recommended)"

  depends_on "pkg-config" => :build
  depends_on "bison" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
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

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
