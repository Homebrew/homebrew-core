class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v23.5.9.tar.gz"
  sha256 "fa0036f4a2d082f7034fd90a53a02ce0e121548b39c07c8d2a77a821da02fb01"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6d549bec6cbb5ebecda7fa38456a0292765dd6be9db1281599a27882eeebc18"
    sha256 cellar: :any,                 arm64_monterey: "3ad531c80f4d40f0e0d57d451a4874ac8df16a0d079566d85cb45938c3644f2e"
    sha256 cellar: :any,                 arm64_big_sur:  "4dadf75ff60700f2e53ed29711e904d9b1f4a394ff5262fde9e14ecbcbbc9b6f"
    sha256 cellar: :any,                 ventura:        "fe6e360d212f1570de2f3f8c6ebe7be5d9b91c85880671240875fb2ca8dd33b4"
    sha256 cellar: :any,                 monterey:       "bb65480a50d00a601e4e3f1c7a04df701494a768a431ed6b6f7c7c8664ba0223"
    sha256 cellar: :any,                 big_sur:        "c3e82d48b6e3c2892e8f479a3a35120f8d21c4c4b78d2a9d95663e46c45ba81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5457d2124ebe0c87c5ea91bc3f9fe3c28f557410c5d19238fb569890e7772d5"
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
