class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.0.tar.xz"
  sha256 "aafde6275e498f34e5120b56dc20dd15f6bb5e9b35ac590f52fde5ad6b2c7319"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f54d4ca089873e9b34724701215f4cbb3d0a58e84729ea1e00653df4b0e21a70"
    sha256 cellar: :any,                 arm64_big_sur:  "6695f8e918ff63ac750970467ddc3c3143eb5d8c9198884b99144d4fa964d18e"
    sha256 cellar: :any,                 monterey:       "d42110f4783969867468ff0d8b510ca0ae91ea57a2a0d362d61bf979b3e9f20c"
    sha256 cellar: :any,                 big_sur:        "f2ae11a9c9581d49eeef3f7e18ea5b69b03646390a564b0addff11098d523f84"
    sha256 cellar: :any,                 catalina:       "0f5ddb7b7ccb246e6c18cbe18ab328e36a7509c1d2b1b3b474ecdb1e11c5bbdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66b6fb5879df30ae0af6391ea1704b01adf6d7c117f6aab8de516090368348e0"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "imagemagick"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "docs/chafa.1"
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 2, output.lines.count
  end
end
