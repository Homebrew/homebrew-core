class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.13/hwloc-2.13.0.tar.bz2"
  sha256 "52e936afb6ebd80f171f763fcf14f7b1f5ce98b125af5dd2f328b873b1fd0dab"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.open-mpi.org/software/hwloc/current/downloads/latest_release.txt"
    regex(/(\d+\.\d+\.\d+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f8b4882a8b58c18900e03bb2ecadabc828ba3a50978fa33e4d9c8f4c83fe674"
    sha256 cellar: :any,                 arm64_sequoia: "ad9de3dc933720a5e61ef567bee28793b5c283055d51a79e984133b37cc0d635"
    sha256 cellar: :any,                 arm64_sonoma:  "841bca31067f7ae880010f9abacfc9bb59f2d675d51afdfebd768b06b1cbb7de"
    sha256 cellar: :any,                 sonoma:        "2232073d9ed0f9d2783309ac0963b0042b2b9db381699a5b023cee251be0c86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147461c3c53fb69fa1985ede4a7a1da3d658c675f6d380d51788b7d29c457fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e4c018c3758ea1f9a6124ea34c1832a71b34b97c5fdab3fe25343f9f2f5fb4"
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
