class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.10/hwloc-2.10.0.tar.bz2"
  sha256 "0305dd60c9de2fbe6519fe2a4e8fdc6d3db8de574a0ca7812b92e80c05ae1392"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "19cbbbca07f9a59c9616df503effac71e54c077b534d9326f4df8c9525c1a3c4"
    sha256 cellar: :any,                 arm64_ventura:  "fc15adcc45bafd0bbf640875501375c8b64a6b857960c20ac771dfadbd3a0a0f"
    sha256 cellar: :any,                 arm64_monterey: "4e3a3403dcb48a28115689ac204ec581765280b75458a7fe5074d919dc6641d4"
    sha256 cellar: :any,                 sonoma:         "0060d6e3988ea5ce00e7f73940b42f107a4800e644db12cdb24cbe2fa5c557c7"
    sha256 cellar: :any,                 ventura:        "bd8025b89ae95b6f5af1686e217533e9890ea454415b3e34adccaae34ef5aefb"
    sha256 cellar: :any,                 monterey:       "403695717af1e987d7c6e297942657a4adadf69858cc29de9be7081d2e8013c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e85eaa4947cdf8fc3ea0d14034ece7ad3ee3dc7ef7d687cad3575014024a5e"
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
