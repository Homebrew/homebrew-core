class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.18.1.tar.gz"
  sha256 "a755c472d7c9e54bc3aa6c92a847a69466fbc6cdc56ee912f411802a725d57a4"

  bottle do
    sha256 "7673b68e0fb01e2ca7126d7fa24f7fb486be147eab203555ae887a2a8fd63ca5" => :sierra
    sha256 "024ce54a0d4192fdc537fc1e343b48bb19f9018a46ff596b3f09cc88f4906ba5" => :el_capitan
    sha256 "8cddd4d9c355d8f620264e984d9ef3751bb1833344972255855b6e75055a13bf" => :yosemite
    sha256 "d990821b7e00a3d7640b9caeeb29b27787a2df74cf868db0a2878b1055f8aeee" => :mavericks
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

    # Let's try removing this for macOS > 10.6; old note follows:
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
