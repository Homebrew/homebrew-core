class AvroC < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.2/c/avro-c-1.11.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.2/c/avro-c-1.11.2.tar.gz"
  sha256 "9f1f99a97b26712d2d43fe7e724f19d7dbdd5cef35478bae46a1920df20457f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b04715d07a7b86605570d4c1cefb4a784eec94a439afce5c53f04e4993b3e5c3"
    sha256 cellar: :any,                 arm64_monterey: "ecd0e6cae754d2dee7b07be2c0c05d32488ecf4f60a1d6d282d342844fbc50be"
    sha256 cellar: :any,                 arm64_big_sur:  "3e8cfc7191ad79c820f528bfff349667db31f4c8e11137982b26072924e46f7c"
    sha256 cellar: :any,                 ventura:        "51030bee05f8e25587334eb4c08f687860c46e6c3285547ca10575909e6692db"
    sha256 cellar: :any,                 monterey:       "0a490e95841fd1afc7e101963aad7485c3a791ba23429a993e0e55dab8c3de89"
    sha256 cellar: :any,                 big_sur:        "1e06df4db7975bc94497ad4dfab39b9879400b421495abef6981354a2bc5fd00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a15848747806cba35a46abbaafa68b8f67f8d8f3ed9eadf2fcf4c5b36db0d18"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "snappy"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-example" do
      url "https://raw.githubusercontent.com/apache/avro/88538e9f1d6be236ce69ea2e0bdd6eed352c503e/lang/c/examples/quickstop.c"
      sha256 "8108fda370afb0e7be4e213d4e339bd2aabc1801dcd0b600380d81c09e5ff94f"
    end

    testpath.install resource("homebrew-example")
    system ENV.cc, "quickstop.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lavro"
    system "./test", ">> /dev/null"
  end
end
