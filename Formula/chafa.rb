class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.12.1.tar.xz"
  sha256 "f08cbcd87f604ba20cf8699dc107349400f21b825be20491e8e0ada8995194ea"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70130850f6fb9ce4419533fe1bdde9ca6b203983b53f8bfd1d1c32bbfdef45a6"
    sha256 cellar: :any,                 arm64_big_sur:  "c6dd81cf85d06f1c77251503bbf3964c8720f6d85b9d12eeddf1f3cdcfc2a62a"
    sha256 cellar: :any,                 monterey:       "3e2d48804ceae24704c762ea4f8c2c5b0341b2eae057130703f626fdead1021a"
    sha256 cellar: :any,                 big_sur:        "e7288d43e6f3cc5d86e3a3049d1f31e9f11a035cc058e29ee19f95d812fae26f"
    sha256 cellar: :any,                 catalina:       "459903f3f41b1fb25711930440e69558ac6ac38ae0f9388a21583f42051f2d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ac74f07964555d5ca7494586fa79a72f65288e1aab4d9dae15282fdb1999c1"
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
