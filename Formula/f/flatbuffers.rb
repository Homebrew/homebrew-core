class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v25.1.24.tar.gz"
  sha256 "0b9f8d2bb1d22d553c93cd7e3ecf3eb725469980a58a98db6e21574341b4ed63"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "beacf9ab6026cd2301a294d12a39947e80a7a39756cd0d3ef3e451a07154fafe"
    sha256 cellar: :any,                 arm64_sonoma:  "1fa7ccdc34cf8913caf8b2bda2d6d387c737e35b86e2de4db4401b137b361c85"
    sha256 cellar: :any,                 arm64_ventura: "d7cd7aec91a27c0440f2a8e9f20da7adb0ba5b892b116e691207511102cfcf19"
    sha256 cellar: :any,                 sonoma:        "f5f3d819c251dd1b4713a0f68367f5ff636c4aabdf1909f7ab347f320df6f0fc"
    sha256 cellar: :any,                 ventura:       "cde15451e055680668466a72399e4d369d9ee5b755534935755b952e1b0bae28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6ffc45dc92a1b51a42bce65ec5be86f4fb1c17fe7db4c30c8dd3c86d9c2752"
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
