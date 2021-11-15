class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  # Remove `stable` block next release when patches are no longer needed
  stable do
    url "https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.39/pcre2-10.39.tar.bz2"
    sha256 "0f03caf57f81d9ff362ac28cd389c055ec2bf0678d277349a1a4bee00ad6d440"

    # enable JIT again in Apple Silicon with 11.2+ (sljit PR zherczeg/sljit#105)
    patch :p2 do
      url "https://github.com/zherczeg/sljit/commit/d6a0fa61e09266ad2e36d8ccd56f775e37b749e9.patch?full_index=1"
      sha256 "8d699f6c8ae085f50cf8823dcfadb8591f7ad8f9aa0db9666bd126bb625d7543"
      directory "src/sljit"
    end

    # https://lists.gnu.org/archive/html/libtool-patches/2020-06/msg00001.html
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    regex(/^pcre2[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f0633818b37d8d3ce88c882e048ada77e58f1f445a41e35b028d23e8866fc5ab"
    sha256 cellar: :any,                 arm64_big_sur:  "935bb0c71f1ab79e0ef2593b519b62b5489d87d4571b320cd8f93050c820c450"
    sha256 cellar: :any,                 monterey:       "07b546fdbe6af636fc750abb0104fecd998bc6f40899a75229f89b49f96c1e3b"
    sha256 cellar: :any,                 big_sur:        "3b6478346d722d13c9dd556a90949319417224006939b1e46b06a189dc8c5262"
    sha256 cellar: :any,                 catalina:       "583378673b021a431d4f987ae609fe2a53f834c4e37bca20178e48e94efe77cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8b88708df04038ec6e29fbecd7b4c7d1d7fa8792da09aa56401de8117b5e3b5"
  end

  head do
    url "https://github.com/PhilipHazel/pcre2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pcre2-16
      --enable-pcre2-32
      --enable-pcre2grep-libz
      --enable-pcre2grep-libbz2
      --enable-jit
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
