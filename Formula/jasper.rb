class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.1.tar.gz"
  sha256 "7cba519b98e59725bee2c6234cf75a44a28b000780d019466a13425c5c126061"

  bottle do
    sha256 "362a325e069e0929def99a97ffad3d7dad2ede225e5c21120c451904df14c12d" => :sierra
    sha256 "0affc75abd83953699c90f1b405333350ce5673952976f5f5e9962f221c4c038" => :el_capitan
    sha256 "50c0c3214b87bdf3fd875f3f4b70dfe9a9fc1fe3a1e5ed113a595f995b862c50" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "jpeg"

  # Remove for > 2.0.1
  # Prevent libicns build failure "jas_config.h:6:10: fatal error:
  # 'jasper/jas_dll.h' file not found"
  # Upstream commit from 30 Nov 2016 "Added jas_dll.h to the list of header
  # files in src/libjasper/CMakeLists.txt"
  patch do
    url "https://github.com/mdadams/jasper/commit/8bdcbe0.patch"
    sha256 "cfb7b2e363014adddb49f496313682c9f54356effa51bf74a17ef37c3e58511c"
  end

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
