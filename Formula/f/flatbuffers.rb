class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v24.3.25.tar.gz"
  sha256 "4157c5cacdb59737c5d627e47ac26b140e9ee28b1102f812b36068aab728c1ed"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5f810c9f7fa1f1071b4c8dea28b7966d737edb5991a5535385efd6207cf203df"
    sha256 cellar: :any,                 arm64_sonoma:   "90e5222fe1fa49beff198a81085dcdf91767a9219fcf110db25d266d826284be"
    sha256 cellar: :any,                 arm64_ventura:  "c90b3e2eed62af7b9a4b7a2988e1d932af1bafeb13a56d49a5cb784d7dffb26a"
    sha256 cellar: :any,                 arm64_monterey: "8a5bf9c0f50d3f05e7e7758c9f75fb31fd794f9278c0ffd78cc34b6ab83a48e6"
    sha256 cellar: :any,                 sonoma:         "9ab97400e8b6418b64cc5b3a78059106160f26961d3c8f68e61522e5e7d89d41"
    sha256 cellar: :any,                 ventura:        "557e248c8c2d42f33827a2456fb0bb87ddadbee71aeaade663df51e8af76565b"
    sha256 cellar: :any,                 monterey:       "950ec2ace2073968a4b6cd1b1fb6b9277204ed4a0d1d3f30755fab6fa64b8bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb0221b1fb16b3ad4a88aad4078452c8a51e318ee8927c3c1d82fb44c68b053"
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
