class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.10.0.tar.gz"
  sha256 "3714e3db8c51e43028e10ad7adffb9a36fc4aa5b1a363c2d0c4303dd1be59a7c"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc51298d7bcf8e3787a3b67f92573571a06e5d54c11ae9551c4c2dcaf6143a3b" => :mojave
    sha256 "e5605a8aad6a90cec130a9c80b4c1ab9128175bbeafe9c7bf47e2a47967fc0c0" => :high_sierra
    sha256 "6bcfce8e2e75744a7599eb3cd9ed3773b5790db8d5b605c4672747e891e8fa3c" => :sierra
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
