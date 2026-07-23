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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2ea02018611e3a89bd678dc6e1daa778ed958dc03d69bdc4a447cd6c43502ff7"
    sha256 cellar: :any,                 arm64_sequoia: "0631ddddd165edc2731f57d2b3cf01513c202b4fb68a8b8d9eece1c24ce9c487"
    sha256 cellar: :any,                 arm64_sonoma:  "b68eec2280cf90bec44ef151944a540252118d79233acbcf67e9211a7a4c0a47"
    sha256 cellar: :any,                 sonoma:        "f3207ea97421c3105dda00945d0382f71fc3c2345b9171c28325cb032094878d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0211d900e4e2ec8d216be3435a9146a811c259add289e0b92e53deca7596f83a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b929b424d3049ee109d5974d83589f92d3f7303b35a597a429334f62bb4e8e4e"
  end

  head do
    url "https://github.com/jsummers/imageworsener.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
