class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v23.1.4.tar.gz"
  sha256 "801871ff3747838c0dd9730fc44ca9cc453ff42f9c8a0a2f1b33776d2ca5e4b9"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c0f6dbd551eac4168e08f0e1a26b710a1c4f76f79fcc428b7155070edf9de54"
    sha256 cellar: :any,                 arm64_monterey: "d81c9edea9f784e4950c4a763a126e75e44b3c1d9660b77dfbb1f355ef79d414"
    sha256 cellar: :any,                 arm64_big_sur:  "00154b682acac3e8dc3edaa61f0adb78955f171a3859230fc69143d591453c68"
    sha256 cellar: :any,                 ventura:        "e3fb8a9ecbda4ccfe957bd5e5ff057981f06570b6162bb5f0a1f4a3bde0ed5ae"
    sha256 cellar: :any,                 monterey:       "25bfc55e2da1a3a3134e5e10ed3401aa9d9f8e6dc91d6e6ff5017387cf7620e8"
    sha256 cellar: :any,                 big_sur:        "c94968e2e1c9ab5531c7f20e9df39ffd4a4b2101816afbb8be68a38abb7c7005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "955fbfbf584c69da3723708b59bbadb547a48cecf15de24a62abee3ac32b6af7"
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
