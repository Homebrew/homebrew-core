class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.2.tar.gz"
  sha256 "0946f8e82eaf4c51b7f3f2624eef89bfdf73b7c5b04d23aae8d3fbe01cca3ea2"
  revision 1

  bottle do
    cellar :any
    sha256 "e3da0b7bd45f393eb8dd514473a956f7954a6b1e7d5af7e5382b67b9a21d1510" => :sierra
    sha256 "4bf452a3350cf9121ba3bd7dff9f63bc83bcda4c5e4be194cb1e8cd521a0a0b2" => :el_capitan
    sha256 "3770deb61aade00b379e422691f4e2b4d13559b5493dd54bc13265b556df1a76" => :yosemite
  end

  head do
    url "https://github.com/jsummers/imageworsener.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "webp" => :optional

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-png" if build.without? "libpng"
    args << "--without-jpeg" if build.without? "jpeg"
    args << "--without-webp" if build.without? "webp"

    system "./configure", *args
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
