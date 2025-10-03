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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7c93f1acb04364dbca924bc427a320904269079da6f965a2954f3600d4ae2c23"
    sha256 cellar: :any,                 arm64_sequoia:  "2f5e92e748e1e1993f68bf0e8313742c972c9b466ff60a307c4b8eb3c12ab388"
    sha256 cellar: :any,                 arm64_sonoma:   "5b595eed5b2b5cd87dd3f6cf4585b3a0709ec9a4e7fddc64a54f29056133fee1"
    sha256 cellar: :any,                 arm64_ventura:  "14a343a159b3410196cc3ed40b0e674b4bed5f8ee7b2760b49b1317e1a09811a"
    sha256 cellar: :any,                 arm64_monterey: "0d8c2dab98fa032f871df63f93ae33d4d1a989fe7c97f185d976d976f243134a"
    sha256 cellar: :any,                 arm64_big_sur:  "50063cbefef7614047703983639adaee5836d68c02f673aed62c38fea1c4418d"
    sha256 cellar: :any,                 sonoma:         "dad022cb391e42d43f72c3e7f3b2e2fb3bfb28b2c933d29790c8c863086c4518"
    sha256 cellar: :any,                 ventura:        "d360400241b1bf7a2199e04034e96da619f19c0473c17bf7637555fdaab73421"
    sha256 cellar: :any,                 monterey:       "443be530e6d93e197026cf8ec457817446c38c94d84b39a3ca76e7a2282225ae"
    sha256 cellar: :any,                 big_sur:        "7ce254b5dfb0dcd52e39b682cfd21ea665601cd14e9a2a5ab0c923e185ad5261"
    sha256 cellar: :any,                 catalina:       "7301d5557860b7402e3d624c77a208c1e3eb1ed69479d6d3d3f1158a3e3ea079"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aba845ffa91fb356cfc4f89ef25e24761c0586d43a820cf69013b72e9afe713b"
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
