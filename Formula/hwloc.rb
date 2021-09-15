class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.5/hwloc-2.5.0.tar.bz2"
  sha256 "a9cf9088be085bdd167c78b73ddf94d968fa73a8ccf62172481ba9342c4f52c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1df444fd7640dff4306508bcf2baa3f5a9fb83db7646897fd31421034f5765ac"
    sha256 cellar: :any,                 big_sur:       "d0b225d121dcd50e56b2b592a2670f05e94d48316cd37e6c254c36b99690e278"
    sha256 cellar: :any,                 catalina:      "39a52a77a6f45eed5601095cd8e4e96e978683fab21231547367903d21943ead"
    sha256 cellar: :any,                 mojave:        "27fe1f8278655b12f5392ea303c3c3083ab71bb8db42a111192e6e72bd898c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e5133fba92e2c0ef66f0fad789f18fe24240f4a48cae9b4696f1b4731801a7"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-cairo",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"

    # remove homebrew shims directory references
    rm Dir[pkgshare/"tests/**/Makefile"]
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
