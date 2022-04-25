class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.10.2.tar.xz"
  sha256 "171042f71f4a1da72322c170d81c4715ac5ac2c907aa663912f74b7a4b1b9bbb"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "001cfbdd291c9d24f066ac7994bbe65cc3ad56c2ca3201c0b36a98eaf091d8ef"
    sha256 cellar: :any,                 arm64_big_sur:  "abccbc69d009205118dd7c7dedbd0cd8cfefaf315ab79b2b1ae2ff714cb79ee3"
    sha256 cellar: :any,                 monterey:       "ad572bb07bae23e05f35bda8692eccaff559d42a244d53c0ced8784d044881ab"
    sha256 cellar: :any,                 big_sur:        "308a7c8621f1b2ee94004861b980e59d22444266f297061a2fb7dc691c50fc2a"
    sha256 cellar: :any,                 catalina:       "a0a68df960c9d5a9b78e65b3217298c3c0faca0f42c173c17c1535b35629b880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05831d8b3fcef5792bb92162538e664e205afe5ab189f2e5179f8f66ad0d8780"
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
    assert_equal 4, output.lines.count
  end
end
