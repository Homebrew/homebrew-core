class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v24.12.23.tar.gz"
  sha256 "7e2ef35f1af9e2aa0c6a7d0a09298c2cb86caf3d4f58c0658b306256e5bcab10"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28f8e16a95b96e48d042009d32a1045e61384d89f02e7b49374531dcdf37ffa2"
    sha256 cellar: :any,                 arm64_sonoma:  "ba0ab398a1b519f6f76f304c03afc1922f95c64a34ea6cc59e98806ab8742d77"
    sha256 cellar: :any,                 arm64_ventura: "599860a4cfadd559b0b7403d73e9b8eb581afc55390955659767d416ce39fa8e"
    sha256 cellar: :any,                 sonoma:        "0bd8085554688dec144bf26a1e18b0ad0d0cca66c25dbaeb8287646170b8fb62"
    sha256 cellar: :any,                 ventura:       "45590ed0cf730355d7def00f33be726a3a3b9e5c4c1dc8a13b25f1119f70de20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd4535fdef9ca00323ea310de185911f9225e2aae4508edb78ef6d9bbb30591"
  end

  depends_on "cmake" => :build

  conflicts_with "osrm-backend", because: "both install flatbuffers headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DFLATBUFFERS_BUILD_SHAREDLIB=ON",
                    "-DFLATBUFFERS_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testfbs = <<~EOS
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

    EOS
    (testpath/"test.fbs").write(testfbs)

    testjson = <<~EOS
      {
        pos: {
          x: 1,
          y: 2,
          z: 3
        },
        hp: 80,
        name: "MyMonster"
      }
    EOS
    (testpath/"test.json").write(testjson)

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
