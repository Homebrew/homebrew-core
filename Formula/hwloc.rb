class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.7/hwloc-2.7.0.tar.bz2"
  sha256 "028cee53ebcfe048283a2b3e87f2fa742c83645fc3ae329134bf5bb8b90384e0"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{href=.*?/software/hwloc/v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c033ad4dd4c6b866fe22f2deceef505973eea7fb76092ccfa400018cd36c5bd2"
    sha256 cellar: :any,                 arm64_big_sur:  "16d40e7dfa7ab9ea53ee88321e50fb16877b1df0ac02ee9e386a0bda45825f4d"
    sha256 cellar: :any,                 monterey:       "c0374b2d6e812a9bf14685ec78753fb23f06a5de365fff8bc5690784a0409a21"
    sha256 cellar: :any,                 big_sur:        "b7f4d9ef56ce804956d4e2536376b905adfc983fc3458f6afcb57d979e80718e"
    sha256 cellar: :any,                 catalina:       "da4a859b1e40b723d8e978e6218b121ababc4eb69d71385d202d915c6fa82afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7cb17122eac687a24b0faa2fda22ccc0b97142ad4ed05c5213e8d77a66df7e6"
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
