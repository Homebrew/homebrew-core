class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.2.tar.gz"
  sha256 "f8285b94dd87fdc67aca119da9fc7322ed6902961086142f345a39eb6e0c4e29"
  revision 1
  head "https://github.com/mattes/epeg.git"

  bottle do
    cellar :any
    sha256 "0b8e74245b9df2388cfd2f37f24545fbcf1cc54d3ba1e5a90658af88feb39618" => :sierra
    sha256 "c9293a9f73cd919ccf6872c227758000697d161cf703afa35a011317198c7048" => :el_capitan
    sha256 "92edea88dc585ce8a743173d7c27ade8649e5a0e026a8d7e3adabad4824f55fb" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libexif"

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epeg", "--width=1", "--height=1", test_fixtures("test.jpg"), "out.jpg"
    assert File.exist? testpath/"out.jpg"
  end
end
