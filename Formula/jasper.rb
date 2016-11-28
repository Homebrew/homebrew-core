class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.0.tar.gz"
  sha256 "37fb86fbdc880e8ee566cf2ac226f0bfe259394914fad4d9e26bbe0764f8c378"

  bottle do
    sha256 "362a325e069e0929def99a97ffad3d7dad2ede225e5c21120c451904df14c12d" => :sierra
    sha256 "0affc75abd83953699c90f1b405333350ce5673952976f5f5e9962f221c4c038" => :el_capitan
    sha256 "50c0c3214b87bdf3fd875f3f4b70dfe9a9fc1fe3a1e5ed113a595f995b862c50" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    ENV.universal_binary if build.universal?
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
    man1.install (prefix/"man").children
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
