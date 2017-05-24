class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.2.tar.gz"
  sha256 "0946f8e82eaf4c51b7f3f2624eef89bfdf73b7c5b04d23aae8d3fbe01cca3ea2"

  bottle do
    cellar :any
    sha256 "79d62b82a5d98f7d51598ba6cc70df5dd4e751a6343031e0271bfb8182a14747" => :sierra
    sha256 "cc99a6e3155b29e82d2f49b727197272570b9a69db56523bdc3b17d520aeb65e" => :el_capitan
    sha256 "61cf20408c2169d6f76c1556cb577eb4992a33d214395c17c2ce472d0adf4506" => :yosemite
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
