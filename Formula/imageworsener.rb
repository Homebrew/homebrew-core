class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  url "https://entropymine.com/imageworsener/imageworsener-1.3.3.tar.gz"
  sha256 "7c4b6e5f3da333e336f014805c441bc08aded652dd9dde2abd40be33b1aa3e25"

  bottle do
    cellar :any
    sha256 "7ecb9c599da11d86cc8bc9e46d2758422cad1bb39e94c3b398536b7c144d4def" => :mojave
    sha256 "1b8964b45f496d8e35c4dc72f2c26b51fa47d301fcd951f109e5062b9dbac13d" => :high_sierra
    sha256 "e3da0b7bd45f393eb8dd514473a956f7954a6b1e7d5af7e5382b67b9a21d1510" => :sierra
    sha256 "4bf452a3350cf9121ba3bd7dff9f63bc83bcda4c5e4be194cb1e8cd521a0a0b2" => :el_capitan
    sha256 "3770deb61aade00b379e422691f4e2b4d13559b5493dd54bc13265b556df1a76" => :yosemite
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
