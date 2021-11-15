class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.4.tar.gz"
  sha256 "e34a628a8142643b976c7233ef381457efad79468c67cb1ae0b83a33d7493999"
  license "MIT"
  revision 1
  head "https://github.com/open-source-parsers/jsoncpp.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a52ec1a9b0cfc5e1daa8e181d9a40c8e134ed4d5e36afdaee9809c26e67ef70e"
    sha256 cellar: :any,                 arm64_big_sur:  "e8698be8b88f02ce485d1b787f0dfd478360861998cb14a024b13f28d89ae24d"
    sha256 cellar: :any,                 monterey:       "1f4c6f014393011d337d7c4bf30baa5a94dc4ab41f17a9ea589d688c66598fad"
    sha256 cellar: :any,                 big_sur:        "83f3e13fd5d02667707d4f8e9a4507bd1f7ff5df5c2a9b049a36cd4597befb39"
    sha256 cellar: :any,                 catalina:       "ecb519ab6a3d662893a69c18a047b30e6092ee31554ffc5756a53838320e6d9a"
    sha256 cellar: :any,                 mojave:         "8a052407837f69662e243ec46bfe81faefafba89b31ec95d6953b9a3b7d1603e"
    sha256 cellar: :any,                 high_sierra:    "85a862e7c2b2d381de4158ea6e574d92711cc7e311af7b01e9146f34d2da5f67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f542a14ed2812abdf362dc3ff04320d960cbfba8abf1f4bfe6556ed2718dde7d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython=#{Formula["python@3.9"].opt_bin}/python3", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json/json.h>
      int main() {
          Json::Value root;
          Json::CharReaderBuilder builder;
          std::string errs;
          std::istringstream stream1;
          stream1.str("[1, 2, 3]");
          return Json::parseFromStream(builder, stream1, &root, &errs) ? 0: 1;
      }
    EOS
    system ENV.cxx, "-std=c++11", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
