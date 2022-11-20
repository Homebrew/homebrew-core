class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v2.0.8.tar.gz"
  sha256 "f97965a727d26386afaefff950badef2db3ab6af9afe23ed6d94bfb65f95f37e"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c991c58076e48ea56e95bb4fc686509bf405a2c1bfed1aeeb61563b7d24bfde"
    sha256 cellar: :any,                 arm64_monterey: "cbe115fdd3ad2a51b390049dd29c9cfe0ca1fde327ff4cdc1e695920f4ca26dc"
    sha256 cellar: :any,                 arm64_big_sur:  "400cd4e592180a130953391370c6401996b046fd502d9674b0cc3a9b4b7a2988"
    sha256 cellar: :any,                 ventura:        "e4bfece8a5f753df8a04ffb5bfaa91b48f14bd7aad4860b892302d216be77d5a"
    sha256 cellar: :any,                 monterey:       "85bc64d4481927fe45ae9be89bc6b7bfa3119a73473589fc7dacd6805257b8f8"
    sha256 cellar: :any,                 big_sur:        "c49ad3a0896e13aee915da94fff43492c166c2037d4b638ae236ce83e9e4dfbe"
    sha256 cellar: :any,                 catalina:       "1bc32cb31d07c392a63bbb5be4a3b8d4fbba7ea52b9df6564051fda444e00324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a447e4f79cd3b75db0692f3b3082a841d35be1d5c82c326f30631ff22cdeaf"
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
