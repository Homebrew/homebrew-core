class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.0.tar.gz"
  sha256 "37fb86fbdc880e8ee566cf2ac226f0bfe259394914fad4d9e26bbe0764f8c378"

  bottle do
    cellar :any
    sha256 "ef1142ea83ad6a5ce3a92d64e80685c1447a87d2062bde5d456b626fb620e5d3" => :sierra
    sha256 "d262d3b14633bff763b58871de361eacf9354d8017a76430cfb957da1fed32a4" => :el_capitan
    sha256 "bc8e00968ac570ddecb7a78796ae245e29ef9326d8ace577ce29ba96b12f87c4" => :yosemite
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
