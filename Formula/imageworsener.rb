class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  url "https://entropymine.com/imageworsener/imageworsener-1.3.3.tar.gz"
  sha256 "7c4b6e5f3da333e336f014805c441bc08aded652dd9dde2abd40be33b1aa3e25"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aacd92bafc82b48324943219b9354ca99cef3e36c31f2ad82b12253d15cbd071"
    sha256 cellar: :any, big_sur:       "3391e73af0da2054295db408889f460025d789d6088162dd92ce67229fdfb564"
    sha256 cellar: :any, catalina:      "fd72a318b2e8b398544d23b384cc4070f181537816647a16129dbbb3628dcc4e"
    sha256 cellar: :any, mojave:        "b5e6ce352f0e698cf10452d273ae0e61f50554565f77010de4e62a6fdddd911f"
    sha256 cellar: :any, high_sierra:   "2332dd0ecedf78344ee5fbd3d00abb0eccc7b28b7e8609c9a18e8e6ab81669de"
    sha256 cellar: :any, sierra:        "847f3211aba4095e280d589a87698234b7cd6e3ec77a6a50cf578a3fa6d0236e"
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
