class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.11.0.tar.gz"
  sha256 "3f4a286642094f45b1b77228656fbd7ea123964f19502f9ecfd29933fd23a50b"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7069d703572d441b912b30f970240f1b047ba5f9f73fce1538a798638cc7fa6" => :catalina
    sha256 "7d796ffd01ee8b81de0ffba7ef8dd6c5a85111d2007f2bf06096e461cb2f2210" => :mojave
    sha256 "96246b405f3804a2e0bec7ff4b214fcb009e086a65941018a602f24dfe098c37" => :high_sierra
    sha256 "1ed87e54f40fc6c1df22d379b7efed9517c4e660a457715ebc9397c3bfb5896a" => :sierra
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
