class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.9.0.tar.gz"
  sha256 "5ca5491e4260cacae30f1a5786d109230db3f3a6e5a0eb45d0d0608293d247e3"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ff7c60d4f88899310a9690e4ce0a61652e7435b408ecf0b83902929a558e5a6" => :high_sierra
    sha256 "6cd9702f17cbae326210eec6d6c96f4d568dcc2eea9c256781e96652da463dd8" => :sierra
    sha256 "02461c38c5a9f3404b4b7ada348903a6cd67f83e9eb0af8bc07628a9fe5ef7bf" => :el_capitan
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
