class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v25.1.21.tar.gz"
  sha256 "7ab210001df1cd6234d0263801eeed3b941098bc9d6b41331832dd29cea4b555"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8e6f44ea9900c918a2034bf508e1f2d252fe5a39bcac3b9ca0bace6af88a8c7"
    sha256 cellar: :any,                 arm64_sonoma:  "dcef57d3f36e3c228b5cf30b9c1e030365f18a53880136426bc9dde1848dca84"
    sha256 cellar: :any,                 arm64_ventura: "299be281681e5c1cdd7a6c6d23557bb8db2e0536b8e23c8bc4ae1ef08004a1e3"
    sha256 cellar: :any,                 sonoma:        "d2507f6d7ff316aadfbe9e186ebfffe3533b40bebf3cef4c116c6df7e9dcb3e6"
    sha256 cellar: :any,                 ventura:       "37186762f1f1a5f928c9b972da7d1a1e11119aeba27bd20be7c50a488942bc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77bf45d9fed46bc00875591b109c995c1277627d0e36ee269702afcea7f60781"
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
