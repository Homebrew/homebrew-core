class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v23.3.3.tar.gz"
  sha256 "8aff985da30aaab37edf8e5b02fda33ed4cbdd962699a8e2af98fdef306f4e4d"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41bed661b4685bb18ee01f2b961809edd87f905dfe88ad617abc8cfd0710e56d"
    sha256 cellar: :any,                 arm64_monterey: "dc323c25fb592db857668f9a3bfb912cf7a2fbb3db042f430dd0cb4b1d60430b"
    sha256 cellar: :any,                 arm64_big_sur:  "4e37d3f03d1ae3948b6952d6f518b3f8f0bfed61f4d542f3f0fae3bb4b5c2508"
    sha256 cellar: :any,                 ventura:        "37cc5b96af418233914174d4d7d31dc0b87a18a9499eab96e68a690a418939eb"
    sha256 cellar: :any,                 monterey:       "d7a1eed20df9c5ae981fb7f98fa517113aa2bc79b88b1899002aa73e4fddf355"
    sha256 cellar: :any,                 big_sur:        "965086222342bf387d8cdb68b38df5ff32d2160fb43f35ae0a0fcfd963ecafe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8c0495e43dc190f185dd7161ce05d48034a4acf6c8b7a3ed0ab2b1cdd26686"
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
