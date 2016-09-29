class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.4.0.tar.gz"
  sha256 "d3355f0adcc16054afcce4a3eac90b9c26f926be9a65b2e158867f56ab689e63"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e7a7048a3eddd16f080c8a1267c255bf5e7c08ab9d087d0f64b1f3e4f229cba" => :sierra
    sha256 "11e6a7e4c4b2c7dca2e5582dae037b15f2547aeb3f49ab1fb716f10e5ec65977" => :el_capitan
    sha256 "4b0330850e90721864c2c5a4f73e4efd6fbee006b52cd2f77cdbcd0ac98dce64" => :yosemite
    sha256 "e60373d7db349515b22e81b3b2fe8cdfb3438688b310b90d3e227b9d5d106e6d" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    def testfbs; <<-EOS.undent
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
    end
    (testpath/"test.fbs").write(testfbs)

    def testjson; <<-EOS.undent
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
    end
    (testpath/"test.json").write(testjson)

    system "flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
