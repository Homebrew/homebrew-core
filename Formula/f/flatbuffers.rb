class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v25.12.19.tar.gz"
  sha256 "f81c3162b1046fe8b84b9a0dbdd383e24fdbcf88583b9cb6028f90d04d90696a"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27884d2b962c0f736d434e0cd7bff42c4d4b73aee40fc304af19aa687e392249"
    sha256 cellar: :any,                 arm64_sequoia: "a0bec168703354b47325a5a9cb2b8340e33d549a6daca48589563401235c4d89"
    sha256 cellar: :any,                 arm64_sonoma:  "8a8253232ef44f875c6787363e96a6c8219939e370836688d29c9ff0179345a9"
    sha256 cellar: :any,                 sonoma:        "08403eb4b28bda3d8ee89003b743f5554e18b08e08c6a8f4b48207fa13fe320a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a3a907efeb6111e32a828aae08a2b235f62cfe89b37468337449bc799633246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3cb57c7d5d16d51d47439a7ab56a3a9e275d9912094eba581609003be526ac"
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
