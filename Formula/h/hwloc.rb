class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.14/hwloc-2.14.0.tar.bz2"
  sha256 "966b9bb3e9f29f8d65ce8d106779e457f40e246a645e584b100772a42f9ae94b"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fadf2b01c4d8501f3143482cd8022f0f3af3d6f82da20007bf56e11e49be8e3c"
    sha256 cellar: :any, arm64_sequoia: "8c70695320ac8ce21235f5ca2f5f9017f309d3a6b2cd8882184c4b3a2383e281"
    sha256 cellar: :any, arm64_sonoma:  "4bcf523dc45275b6c7f18cbafea174e15f0e88e4653b15ac5971a93ce50dabd1"
    sha256 cellar: :any, sonoma:        "df9fa8f78e8708e728184396d4721aca222186cd1c314dba20a04d4dccf956ea"
    sha256 cellar: :any, arm64_linux:   "8c02236bcac41db3cffd81bf1ca859ee11e9ef34744d5175396e85326a5c39f7"
    sha256 cellar: :any, x86_64_linux:  "8b4c5dcbbe2171f0f9384915001c086dc2909318ce34b61ba5285644b4222120"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--enable-shared",
                          "--enable-static",
                          "--disable-cairo",
                          "--without-x",
                          *std_configure_args
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
