class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.10.0.tar.xz"
  sha256 "88f4b8b1541f98230af11d4de2e8dc8b8a4c537dbd57dc2f63f2e0a48d3d68ee"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1dc63f05fe4982bb02b729de23038b7c99a8c606b8e2adc6246078ba51e7c45e"
    sha256 cellar: :any,                 arm64_big_sur:  "615181fb380b647190393711bed7795ba1aa1b91c86fba6c472f6662cae6a80d"
    sha256 cellar: :any,                 monterey:       "b09a321e52fa02e51200be9c78188c49a3123255a3c78873ec094f03db6f45ea"
    sha256 cellar: :any,                 big_sur:        "ab8d8a02159a3ce1ba4aaeb42e32cccfa4b35b000b17e42e3756b9ee9f27e5e0"
    sha256 cellar: :any,                 catalina:       "e3ade6349a759071f223360e32e63fe45c60363b76d60ddfa214c60321af460f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a40584e711ca5da234e8ce86e6597f66197d3df8132fc7c5abf716bf1fe9e91"
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
