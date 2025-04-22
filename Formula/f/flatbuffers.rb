class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v25.2.10.tar.gz"
  sha256 "b9c2df49707c57a48fc0923d52b8c73beb72d675f9d44b2211e4569be40a7421"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a66a964c0cf6b035df7377945002013e1a7ff0111926d91fa9024b058663ecf"
    sha256 cellar: :any,                 arm64_sonoma:  "c25c90d8626319975d8898a41b873f77d0f4691c1fd699956d5cf940d2c01212"
    sha256 cellar: :any,                 arm64_ventura: "6968b4b2efa0d5139761970ff456a1ed5d6d5ad7b41e80f4cc9b80fa1c519b7f"
    sha256 cellar: :any,                 sonoma:        "a58461c37e9674fe74fb1f6fad9f0f18b17fdf75dc26735e37bd11f61efaf73c"
    sha256 cellar: :any,                 ventura:       "5d7f236f0fc79666d04189c4ac050584475d7eb6e8ac4dfef1aa7f416c9928d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591bd372c1950a418d9003b7a155b753aef7b894034f708ab4f32d685f19a56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c93870db88b63506938944f084714de60f7a9889d2182c3a0088587b3f91536"
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
