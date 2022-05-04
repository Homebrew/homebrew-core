class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.10.3.tar.xz"
  sha256 "797729e0ae9af1ff084d59b89054e9f59fb419a9f13b846a36d3bead50aabe3c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d5e90692c1975eaf2fd6de06601d5dc00da71b43bd726097a5538c0b2b980a94"
    sha256 cellar: :any,                 arm64_big_sur:  "d064702055239a04785debdfb1337f9fd3a286ccfd17eb3d6de35979e4ed6c59"
    sha256 cellar: :any,                 monterey:       "f5d084b5f3945b027c8a0041bf0fe71d0fa1dc7605e00ef32e8a23b1d2453f67"
    sha256 cellar: :any,                 big_sur:        "c8956bdbeb2a0bbb4525875b2c089bad467edbcdc4dd7e0e2ffe49fd977b1f0b"
    sha256 cellar: :any,                 catalina:       "f78ee0e8889ad13e58e29b92bc731ebaf7388026dbc618ee6cc5179b7400889f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "110de3d3360e9dbf8fddb87590a0b0ee876ce38fc2e6ea0f7f0a4cc69ab5c5aa"
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
