class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.12.0.tar.gz"
  sha256 "62f2223fb9181d1d6338451375628975775f7522185266cd5296571ac152bc45"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9af0beec65e79be83e699b65e8f149d02c3d5980cc65f8caa5dd33cf30882559" => :big_sur
    sha256 "5f02d8f7be90f080e8682fa07365f72116f85449ff8176877b691bbe8c2b3696" => :arm64_big_sur
    sha256 "6af7ac37134539beb7c1003bd2cf8d1e530606cac616239acf4d2b1df31b0dbc" => :catalina
    sha256 "270bebda4048754554cd587d48db10ee5fe1a2795ef6e881cafd1b8f90c7af78" => :mojave
    sha256 "f45982e6ca71b10e59c607b9d984108e1b18fc84b8c52dd23325b6b9211e407f" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    def testfbs
      <<~EOS
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

    def testjson
      <<~EOS
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
