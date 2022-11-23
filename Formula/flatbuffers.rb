class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v22.11.22.tar.gz"
  sha256 "e9fc88136f8558c862dd03d6a9b0893509964edcc92b919de098081245619a6c"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "654f90ef1ab088671a99ff087d02f2868b61a7c86124c13aa8ef7cb5b1e7a43d"
    sha256 cellar: :any,                 arm64_monterey: "f3ec4830b2f4d7002875f37436ca6f53dd825c5192291e2200d70f74df8986e7"
    sha256 cellar: :any,                 arm64_big_sur:  "5c3fb9580f9bbe2c625a42f16382db2a6120ad018f51909a28f33375aed1351a"
    sha256 cellar: :any,                 ventura:        "6e75b1d92d558f3080de9846cefd0d1f35fd0ec89d586c1c528a2ca34218a966"
    sha256 cellar: :any,                 monterey:       "33a571e7706c8f0c96de148f1d3ab2b60a9e03275a968b52dcb6e588e9001306"
    sha256 cellar: :any,                 big_sur:        "40c2f46ed6b787aa0f5f6cb0ca0103a740ff0fe0f6be21d87ca140ce40380c16"
    sha256 cellar: :any,                 catalina:       "928301e3508e349cf611020591810818c7083af68bf423631d17a61c5be7bc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd0d3667d33b79161ee38792b17bcb1ebf93fa5ccfa3c08983756b183c377f6"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
