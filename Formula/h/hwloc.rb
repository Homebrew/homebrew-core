class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.9/hwloc-2.9.2.tar.bz2"
  sha256 "0a87fdf677f8b00b567d229b6320bf6b25c693edaa43e0b85268d999d6b060cf"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.mail-archive.com/hwloc-announce@lists.open-mpi.org/"
    regex(/[\s,>]v?(\d+(?:\.\d+)+)(?:\s*?,|\s*?released)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc7e558a75803dd89d85c54f60bc41af587e7375e76df788fee62586dc05ef35"
    sha256 cellar: :any,                 arm64_ventura:  "0c98fc19c69ec0df1e2271aad05ac922fcaead091349745094db941aab134f2c"
    sha256 cellar: :any,                 arm64_monterey: "a369daeeb4fdfadc77a4522c2e7a23b88918ace52cae98ff323beb1639f3eac9"
    sha256 cellar: :any,                 arm64_big_sur:  "7a2d09c1a4d11296f42d5f758957ed973ca7961e0edd9a16c1573ccdfa36b84f"
    sha256 cellar: :any,                 sonoma:         "44b0787f40c65d8a32a5a080cd92093e78dc5266012ff21140cdd4bac663f424"
    sha256 cellar: :any,                 ventura:        "865974e303ac705663c46b300190e3d6c9a113e89e7aeb5f8f944418e6ff149d"
    sha256 cellar: :any,                 monterey:       "2b3088fc7ba96787b64c7d40c3ba030c510281b3c5cc7c18f6ae3992e5fb2ef7"
    sha256 cellar: :any,                 big_sur:        "2e72696343db02e16dd6af2e68c85bd6aa5c5a64219b85ae912c72cae576f2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac1f1e73b3380275b31e2f12f25f297fe6689f9cefe6a0bceeb535ebc576648"
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
