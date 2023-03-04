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
    sha256 cellar: :any,                 arm64_ventura:  "de52061277db2d3b4d1579eb1bc8540111a8e1443ba2655e397dc1256c1fe32b"
    sha256 cellar: :any,                 arm64_monterey: "1d283f5be342ffc97bb9d9bb32dc6c167dcda4929c512a3c07af4ea19b2c919f"
    sha256 cellar: :any,                 arm64_big_sur:  "1c1566ec3c7c91aa3b927a44e0c601e5d1ef4c7d556ff7987316261a9220a209"
    sha256 cellar: :any,                 ventura:        "3940f1b1c83bcdd893aabca2179d622083754afc6c4d48fcf2ba1e8d8cdc12e2"
    sha256 cellar: :any,                 monterey:       "63e23dd9a91ba2c9b2797c7c812ae8352ce8431a97a0118b6eaee8face890a75"
    sha256 cellar: :any,                 big_sur:        "8a1c4a3cc0e734d904e2ebfcd5aab627677cb0d51c6152d48947a572faedadf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be5708a70902692606b670698d6b617a48c7842b007b675e14981ce4b412a86c"
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
