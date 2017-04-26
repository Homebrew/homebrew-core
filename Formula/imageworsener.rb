class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "http://entropymine.com/imageworsener/"
  url "http://entropymine.com/imageworsener/imageworsener-1.3.1.tar.gz"
  sha256 "beb0c988c02b1d461dccdb3d6c4fc229316a692ea38689874013ba349dff66d1"

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
  depends_on "jpeg" => :optional
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
    args << "--without-jpeg" if build.without? "jpeg"
    args << "--without-webp" if build.without? "webp"

    system "./configure", *args
    system "make", "install"
    share.install "tests"
  end

  test do
    cp_r Dir["#{share}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
