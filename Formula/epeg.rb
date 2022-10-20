class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.2.tar.gz"
  sha256 "f8285b94dd87fdc67aca119da9fc7322ed6902961086142f345a39eb6e0c4e29"
  license "MIT-enna"
  revision 2
  head "https://github.com/mattes/epeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54f06cba442c80a7df90e99c50b1b681863c740f6c653c7583f36a09be729674"
    sha256 cellar: :any,                 arm64_big_sur:  "70a4ef28e4d14c9f48219b1b8e10ce674a6e6539a28fba655bcbc5cdda2ce546"
    sha256 cellar: :any,                 monterey:       "e9a1cfb10c35553fabf7c39994dc1524da44b75c6370c00176734907d74b7380"
    sha256 cellar: :any,                 big_sur:        "4fdf88f8b37fbf5bd56460d0c6ef3e73483c7c13f31ff8e979ae6022666efe0c"
    sha256 cellar: :any,                 catalina:       "328f79a3a50d8d834870a26de6ce4913525151c3e814529a10416d93927f8433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02d2b6f8ef99528282cfa0f547b42f66c9e0b890321a9f6d527477f94769316e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"

  def install
    system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/epeg", "--width=1", "--height=1", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
