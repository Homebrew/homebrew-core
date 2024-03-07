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
    sha256 cellar: :any,                 arm64_sonoma:   "4f6a9bad19abe43ead39f59953950ab18250ac94b01870e436bb7662dcfda104"
    sha256 cellar: :any,                 arm64_ventura:  "76145ff2480451461b8127dbe05e15dbfde947cec68b19b76393d3df04b7074f"
    sha256 cellar: :any,                 arm64_monterey: "eb07d135e07a4b79f39fdd29a79ab0f318e8498d55bf629ccde5a00b17ec5a99"
    sha256 cellar: :any,                 sonoma:         "02cf3a7e4630239395665da773163dba3f515660234e712e20f1051e5a7670be"
    sha256 cellar: :any,                 ventura:        "e7bb7aef25c883261534cd4b7c3abe18631f2218b6bad727e9810b00e3c98643"
    sha256 cellar: :any,                 monterey:       "94455cef86ceb20f464f8504465f473085297e2a9d6dbcbadd427793acb07f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e114b72dc773cfe1d5caea6e0fa48ec872810a23d85886531f039641d3876e"
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
