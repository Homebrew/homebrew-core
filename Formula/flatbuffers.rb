class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v23.1.21.tar.gz"
  sha256 "d84cb25686514348e615163b458ae0767001b24b42325f426fd56406fd384238"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5400c43b38619ae72008e3093b45bb9fa18d276f652d0d0a5e926c1c11eb1cd"
    sha256 cellar: :any,                 arm64_monterey: "105ba558df23cdfe981533f9ffac3ec7598e9b82739bcbee70c284945b0ac4b5"
    sha256 cellar: :any,                 arm64_big_sur:  "7ec0dbbf92b4355b477cfe9438be4741e7d342bee05c34683735d9ac6ab11484"
    sha256 cellar: :any,                 ventura:        "da8bae0fe28175420206098c231a60454531069bd1ea926de0d84abbeeda99b3"
    sha256 cellar: :any,                 monterey:       "e70919f88cbdefc2304544a96ce5e88b9b121310c06ebd3d7b6627e269592f36"
    sha256 cellar: :any,                 big_sur:        "35b5c00fec50c3016166c9985a590d5be7b37c1fbaff02a42c0fc45ca35a9536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a9f5554e429379670e137ac5ca47c7b21d71b705f410802f837edd2fae12b9b"
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
