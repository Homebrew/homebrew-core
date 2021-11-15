class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  license "MIT"

  stable do
    url "https://entropymine.com/imageworsener/imageworsener-1.3.4.tar.gz"
    sha256 "bae0b2bb35e565133dd804a6f4af303992527f53068cd67b03e5d9961d8512b6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "59a3ec8b38b32f1dd73a0e68ed6b04143f5f017c8e2f67104f1c4b04581a9a91"
    sha256 cellar: :any,                 arm64_big_sur:  "0ee5c5f12bf988c164ce3ea06ce3c6a22af96427edaf241fb68f91c3e951d2de"
    sha256 cellar: :any,                 monterey:       "daad4e7c113aba1f302eddedf9953ca54f2565698f7338dc0118d5e4978388d4"
    sha256 cellar: :any,                 big_sur:        "6e6ec999be6238848bc4c39f7e39419b39d060dc925273ddbaaa500d63a29f92"
    sha256 cellar: :any,                 catalina:       "a2c33e599d1b1aa2500593919cdc4a9771f5afe71a7f6011a98b125dbfbd9c60"
    sha256 cellar: :any,                 mojave:         "a529b6264397516c763640015683f35632d46befd85fb07a3433ff2ebf2fcd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9018d0001a824d65d6e4205cffe1f745248df78b2341a0922e8a5254849bc672"
  end

  head do
    url "https://github.com/jsummers/imageworsener.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--without-webp"
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
