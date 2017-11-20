class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.8.0.tar.gz"
  sha256 "c45029c0a0f1a88d416af143e34de96b3091642722aa2d8c090916c6d1498c2e"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea96a72c88b9a1ba2f7725fe3ff7884e4b5a5c4415126f468c586a2535cafd37" => :high_sierra
    sha256 "4bc2305d3d22aa17889d7b41fe1a3495590931492876afb2098371c8a9d7d70c" => :sierra
    sha256 "4d5144e5c88a4d2fefde69bfcdf013f9ee3894a7dbb8805bdf20f491dac76c5d" => :el_capitan
    sha256 "0f2b611a3a061dd955f7d842ad4a8c72b13e44664c7afc19b82c76ddcbb0d0be" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    def testfbs; <<~EOS
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

    def testjson; <<~EOS
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

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
