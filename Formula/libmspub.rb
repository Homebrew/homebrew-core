class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 10

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ce4651e3377381fee9beb8dd9dd16dd89662861b8f95b0ac36127258f94f97b8"
    sha256 cellar: :any, arm64_big_sur:  "6a5c5caf43755d2fb8acd3cdd99dccccd515d7da9c501e49fddbc5d5e4500190"
    sha256 cellar: :any, monterey:       "078e46db9a27cf01f94ecbcb2d5fc977418b58a325aadc5f52248e04352a75b3"
    sha256 cellar: :any, big_sur:        "7a42e31ac599a192f1e58d281b7e075e71d52bee9465c763520f17cc1744b173"
    sha256 cellar: :any, catalina:       "56aebbd968cdf49b1da3d79233dab4810af0c7c16e03521db8e5e9499e867294"
    sha256 cellar: :any, mojave:         "f32c702d3d966bc65125394b949999f1789319b2835b45c0638dbb06fbd31b70"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libmspub/MSPUBDocument.h>
      int main() {
          librevenge::RVNGStringStream docStream(0, 0);
          libmspub::MSPUBDocument::isSupported(&docStream);
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
