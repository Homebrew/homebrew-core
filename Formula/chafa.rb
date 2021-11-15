class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.8.0.tar.xz"
  sha256 "21ff652d836ba207098c40c459652b2f1de6c8a64fbffc62e7c6319ced32286b"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "2b99c6720548b49bf464446eb2a88feb723022f67a48628e17f6f64e6d65f1ed"
    sha256 cellar: :any,                 arm64_big_sur:  "4664b6326ef88f1cb9a333f44e3efae718dd36c0b9022fd4f13f94c75aa000b8"
    sha256 cellar: :any,                 monterey:       "da5f1e3983bd385ddc9159bf654bd8db34138fa3072d68ca03761b5b01b1e0a7"
    sha256 cellar: :any,                 big_sur:        "9c435dd20ac686e44a6d0bade2aeb1fc38aab2f8581abcd52edd24fcd481df52"
    sha256 cellar: :any,                 catalina:       "f9d29df82aafb93d30039a25a7fff50eda674fea0df040690aa5e9367be6d07a"
    sha256 cellar: :any,                 mojave:         "59b934180ef0f7bde637fe66f433d0a1bf7f18a0787bb2ea433225c2dffc62fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab71c2288640e08cd267cbf92bb5bd126a7cf30147561891188cfc2f4a6b431d"
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
