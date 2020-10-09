class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.4.tar.gz"
  sha256 "e34a628a8142643b976c7233ef381457efad79468c67cb1ae0b83a33d7493999"
  license "MIT"
  revision 1
  head "https://github.com/open-source-parsers/jsoncpp.git"

  livecheck do
    url "https://github.com/open-source-parsers/jsoncpp/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "8790c09b47eafd5e6c9cb80e8923eb2c4555ae950644ffdd7b48be8757a38765" => :catalina
    sha256 "1222b8d8b45d721499cc0bad57e69e53a01d734b48371b2d5519d47fbe59667d" => :mojave
    sha256 "96b5952e3542637b530cec555628c1e41fa5aeda44c5c9b8fd9619f790f10efa" => :high_sierra
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
