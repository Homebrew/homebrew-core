class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.11/hwloc-2.11.1.tar.bz2"
  sha256 "04cdfbffad225ce15f66184f0f4141327dabf288d10a8b84d13f517acb7870c6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dd30eda9f9e36bce8c9499e455d4b59661a27fbc677c83b9c9f9cf47517f2667"
    sha256 cellar: :any,                 arm64_ventura:  "4a03a0c478558d2b1a7395e4c18d6e168300ee737f8787394eda2aaec65a2cbc"
    sha256 cellar: :any,                 arm64_monterey: "6648c1390e447f0df8e90bcfeecde4f4aec3b51cc94c094b6fca054f633c1cbb"
    sha256 cellar: :any,                 sonoma:         "f5d085652f70ed70430331b371f691de80822c892077e6421cf0423051f60eba"
    sha256 cellar: :any,                 ventura:        "c1919e3cd770b89517da6834913b145298a08ef316b4feb326d2e53459b62bf3"
    sha256 cellar: :any,                 monterey:       "fab9e144be850b7d45915b9a1ab172db0bb1c6360053fb156b9d77624b71e8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4584b0e82512d2cf63bf9f473d479b144b4a586249efedab3e7fd9fc3dccba3"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

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
