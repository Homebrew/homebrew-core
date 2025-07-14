class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.12/hwloc-2.12.1.tar.bz2"
  sha256 "38a90328bb86259f9bb2fe1dc57fd841e111d1e6358012bef23dfd95d21dc66b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90fafd57899d674e5f653f5c7c9d964f992877eb2a1d74364ea9cb14f9063149"
    sha256 cellar: :any,                 arm64_sonoma:  "ed649bbbddd8352d9d7c8e36f9968cb1975b86378a2ee686637977e6f7a59190"
    sha256 cellar: :any,                 arm64_ventura: "1b19f3b8775e2ed4ec5ec212199c136e3f427321bc4fc19c5a35df543405fbab"
    sha256 cellar: :any,                 sonoma:        "270040ceedd93532189119df30d37a666125a16b7679bfb8466e5795d5e788cf"
    sha256 cellar: :any,                 ventura:       "d0052e70d0877350983882f598575d38d81e771fe4d567491eae9f25789d45e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27aadfd1d6983986febec9f2feab8092bbe86561403bcbb6ce1072bcfb0db2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0cdd5ecab9208d5919050bfecdb84dee087fccaa460d4832e4ed3e859441a9c"
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
