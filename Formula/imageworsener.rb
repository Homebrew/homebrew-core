class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.2.tar.gz"
  sha256 "0946f8e82eaf4c51b7f3f2624eef89bfdf73b7c5b04d23aae8d3fbe01cca3ea2"
  revision 1

  bottle do
    cellar :any
    sha256 "ac6900cd8b79e500b8312d2fe9a7a31d11ed7f637623825bcf5b03a9c81cf845" => :sierra
    sha256 "38c3d2aefc1ac3b0e1a0edfde959138f1e2c15e835f362449df2a83fdb7e6695" => :el_capitan
    sha256 "2d0b052c3dedb2adcd7d3fece5dfae0547f7e64cf9a28a91d79833e974c3c5d8" => :yosemite
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
