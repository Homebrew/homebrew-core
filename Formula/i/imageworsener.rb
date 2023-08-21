class Imageworsener < Formula
  desc "Utility and library for image scaling and processing"
  homepage "https://entropymine.com/imageworsener/"
  url "https://entropymine.com/imageworsener/imageworsener-1.3.5.tar.gz"
  sha256 "a7fbb65c5ade67d9ebc32e52c58988a4f986bacc008c9021fe36b598466d5c8d"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?imageworsener[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14a343a159b3410196cc3ed40b0e674b4bed5f8ee7b2760b49b1317e1a09811a"
    sha256 cellar: :any,                 arm64_monterey: "0d8c2dab98fa032f871df63f93ae33d4d1a989fe7c97f185d976d976f243134a"
    sha256 cellar: :any,                 arm64_big_sur:  "50063cbefef7614047703983639adaee5836d68c02f673aed62c38fea1c4418d"
    sha256 cellar: :any,                 ventura:        "d360400241b1bf7a2199e04034e96da619f19c0473c17bf7637555fdaab73421"
    sha256 cellar: :any,                 monterey:       "443be530e6d93e197026cf8ec457817446c38c94d84b39a3ca76e7a2282225ae"
    sha256 cellar: :any,                 big_sur:        "7ce254b5dfb0dcd52e39b682cfd21ea665601cd14e9a2a5ab0c923e185ad5261"
    sha256 cellar: :any,                 catalina:       "7301d5557860b7402e3d624c77a208c1e3eb1ed69479d6d3d3f1158a3e3ea079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffeb2d98cb08aca5974ca2ece5a40a42b5bd6e0c2422f0a3013455d00793883d"
  end

  head do
    url "https://github.com/jsummers/imageworsener.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "zlib"

  def install
    if build.head?
      inreplace "./scripts/autogen.sh", "libtoolize", "glibtoolize"
      system "./scripts/autogen.sh"
    end

    system "./configure", *std_configure_args, "--without-webp"
    system "make", "install"
    pkgshare.install "tests"
  end

  test do
    cp_r Dir["#{pkgshare}/tests/*"], testpath
    system "./runtest", bin/"imagew"
  end
end
