class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.70/bitwise-v0.70.tar.gz"
  sha256 "b8f41f49b9b73ac3abb1e7533a410504f759673fc6e7f35acf56fc82e39cdf37"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b56a9177735b6e14880ec3e4377ca8575ae630c1e297b2536d11110467c9b45"
    sha256 cellar: :any, arm64_sequoia: "6e985e1b549feafa291b5ea826b372f0a327de09ea0b987cd659c9b31b5cc768"
    sha256 cellar: :any, arm64_sonoma:  "56b38b848995288b3833def04e767744d418768b1f760bea1886f26d83135a64"
    sha256 cellar: :any, arm64_linux:   "fa1339df7cd2f3e36b68364bbfd8fd5ff5602511c2f990ddcab90c745efc7a65"
    sha256 cellar: :any, x86_64_linux:  "274a2a9335e2462bd85cf3f3f4d5c1257d2bce3225535d7645b13d09f5b4f013"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    # `inc/compat.h` is missing from the release tarball; it only declares strndup/l64a fallbacks
    # Upstream PR ref: https://github.com/mellowcandle/bitwise/pull/71
    inreplace "inc/bitwise.h", "#include \"compat.h\"\n", ""

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end
