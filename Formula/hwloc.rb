class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.8/hwloc-2.8.0.tar.bz2"
  sha256 "348a72fcd48c32a823ee1da149ae992203e7ad033549e64aed6ea6eeb01f42c1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.mail-archive.com/hwloc-announce@lists.open-mpi.org/"
    regex(/[\s,>]v?(\d+(?:\.\d+)+)(?:\s*?,|\s*?released)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e2cb861fdebc680fe87cf93e10da9691ca63b5fd421fc7dda465d9c212da4021"
    sha256 cellar: :any,                 arm64_monterey: "5a490d201828781f1d09be139c066761c8a21da6fe94eaeeb7833afeae694855"
    sha256 cellar: :any,                 arm64_big_sur:  "c7b3b0ae09b9dbee5ffeb91120082ed0de28d4add7201a7f2399d5bc887f2838"
    sha256 cellar: :any,                 ventura:        "00d295eec199e5a3ec1ac4ca29318755a0678537d47569c101a4020a0cf52495"
    sha256 cellar: :any,                 monterey:       "42fdb0904f29f3f6635783d2d73a70e3ca44e5c95bf9295bdb4d00d23493d10f"
    sha256 cellar: :any,                 big_sur:        "d7ac216b513863293f7c4d029741cefab3eb0eefc003c1562cc7007d782f3b20"
    sha256 cellar: :any,                 catalina:       "2086a4a3b64ca762657b8bac2a8ef798799269911ebb1a12936242d6577be85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3a8ad60253e5559ef20bb0f36a57bc35cb951f91139137fbf65733919410cb"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--enable-shared",
                          "--enable-static",
                          "--disable-cairo",
                          "--without-x"
    system "make", "install", "bashcompletionsdir=#{bash_completion}"

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
