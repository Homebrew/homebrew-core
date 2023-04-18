class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.9.5.tar.gz"
  sha256 "f409856e5920c18d0c2fb85276e24ee607d2a09b5e7d5f0a371368903c275da2"
  license "MIT"
  head "https://github.com/open-source-parsers/jsoncpp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "013a6b0f7beab209b744ef8119ca2a9a29a0c9c90da09f5012fc94fe5cc51ff1"
    sha256 cellar: :any,                 arm64_monterey: "ae110e26c1c8bcb9aa833c0393ddf26f88e3a88f1056fb52c7461dd0af5d7f96"
    sha256 cellar: :any,                 arm64_big_sur:  "a7412f7e1de7b44f22c25ec31fb7a6bd65450d04e2882954f5a282a6e021236b"
    sha256 cellar: :any,                 ventura:        "68fe5f2b8a499ef699890d432985cb53e648a12fc1017e4bcb0be3c616f8982b"
    sha256 cellar: :any,                 monterey:       "be9698795e4f18a424786e6d9920409b4b98fd15fdf9b09e0ffcff5ddc6dffec"
    sha256 cellar: :any,                 big_sur:        "906ff0a3a449611cdb96c7dd0f4e6335c6a10c8564f73fef3f799de955bdb712"
    sha256 cellar: :any,                 catalina:       "3869924df0ab1d78ed2bc4448f0496c64e0f14af08834297319eb782fc070c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00ec8c187ad0787b392125e31b23d0c2b0dcbb4e9f66cfd34570ca813146ab9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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
