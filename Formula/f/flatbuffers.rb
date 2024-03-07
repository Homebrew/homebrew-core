class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v24.3.6.tar.gz"
  sha256 "5d8bfbf5b1b4c47f516e7673677f0e8db0efd32f262f7a14c3fd5ff67e2bd8fc"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88f3be0760771d0923885569cb23612bb116a44ee04d5b10105ebb82ac58ffa0"
    sha256 cellar: :any,                 arm64_ventura:  "6adbf0e725adbd63a44ac1450e994fb3b6689a500bcc3903e41232c8725dcf81"
    sha256 cellar: :any,                 arm64_monterey: "e27839664b582a68dca68091e19a6e915ea34b17d4ff843927044cd2c52c1346"
    sha256 cellar: :any,                 arm64_big_sur:  "8356a0b003118a682c7a9ae3d3d9d03290b95733374bf68ac91d262c53c3f1fb"
    sha256 cellar: :any,                 sonoma:         "88d50763bce296456550dc3a42e3239525a911a571b393881040d80a408e3190"
    sha256 cellar: :any,                 ventura:        "7f06b89cf995641c2907c69884f9f3d163eced0d1f495af6712115c9ec5d1e4e"
    sha256 cellar: :any,                 monterey:       "003177dc250139c22c1c23244ff7fee6b2d07210b6432c3f2b5a735b100d35da"
    sha256 cellar: :any,                 big_sur:        "aebfee6ed53f48a341e4be1d06f45f8dffdd4dbe359fe02770b34da4f84f7aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa33843a2d4802ba3b57b72c9ca35cd0b5ff9ed7eaaace8fa8f1798db785339"
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
