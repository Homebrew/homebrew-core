class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  license "MIT"
  revision 1

  stable do
    url "https://entropymine.com/imageworsener/imageworsener-1.3.4.tar.gz"
    sha256 "bae0b2bb35e565133dd804a6f4af303992527f53068cd67b03e5d9961d8512b6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?imageworsener[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "95a22e3ec38cf958cf529618b473c4d909ebf0a63f419eedbd3a967c2ee59437"
    sha256 cellar: :any,                 arm64_big_sur:  "49a10087ef0a0e2844b1aac81d6288a55a38ae1a44e6838b4839a16d7ede1ccd"
    sha256 cellar: :any,                 monterey:       "5107b352565dbde45e70ecb9c0014d398f1484e0188d67796b567caf6a3d89d9"
    sha256 cellar: :any,                 big_sur:        "8b89eef7348b681120d65279b58a424495a07f74df19c1688be31131a2aa19a6"
    sha256 cellar: :any,                 catalina:       "a7cdd866470feabfcc8c7e602f1765a69aebc122d48b5da391a7ad3661b5b8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bda810cee57ed24f184221afcffa158ee54c8c2e474f8b6b45953ed94f8b2b45"
  end

  head do
    url "https://github.com/jsummers/imageworsener.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    system "./configure", *std_configure_args, "--without-webp"
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
