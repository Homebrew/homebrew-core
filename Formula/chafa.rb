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
    sha256 cellar: :any,                 arm64_monterey: "deadb7d044c91f82f2becd3f703cdee32892b5dd808559aecf7c44087e01ff4a"
    sha256 cellar: :any,                 arm64_big_sur:  "1fa2cd6c1e0909a1b06ad52b394d42305a611a13b2f97336d916917e4a9f2395"
    sha256 cellar: :any,                 monterey:       "b9d82222f2d7ec948e5af12c2470352846b3bdd18737f83e260a15bff0745265"
    sha256 cellar: :any,                 big_sur:        "6739c7f365e403105694fb7bd539348fca8bf1c01cb85700ebb93e8ce46bd904"
    sha256 cellar: :any,                 catalina:       "16153e929a68f9da52fe709793031432b33344717fa3217a93dc2e3887595436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682396e890521341156d6590ae0354d1e5f8f8337dec00bd4d5523d67fbd91da"
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
