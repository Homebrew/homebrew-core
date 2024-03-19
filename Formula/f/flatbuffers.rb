class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v24.3.7.tar.gz"
  sha256 "bfff9d2150fcff88f844e8c608b02b2a0e94c92aea39b04c0624783464304784"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ef3d132da0bb476b9d17ec8044666b736250517cd24320b5a522d9d3c827263"
    sha256 cellar: :any,                 arm64_ventura:  "b2462c2bd4cc29c8bb9e81edf256717b894e69e46a624bd69271829395ddee58"
    sha256 cellar: :any,                 arm64_monterey: "ce5615da659d7ba610994d6722102b813cea3c1703a8cb16f6d1f00a0013700c"
    sha256 cellar: :any,                 sonoma:         "865b954c792114a718115a7dbfafc271db4009a63f5f15d78a4039c67aef9132"
    sha256 cellar: :any,                 ventura:        "1b0167c5bb940cc7cb2ab6f328fb89d8a8e6d4e134965c36b23913d548032069"
    sha256 cellar: :any,                 monterey:       "8f93c4da23d05ee862248eaabd29d500bd4e3e52406f3b2138dc022b6cbde173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d7febb27db2cc5c0e4745e6125419c4dfce521e73bcf866c3cfbd0486b30d4"
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
