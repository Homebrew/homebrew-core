class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.5.1.tar.gz"
  sha256 "8c4560ca32e3c555716d9363bed469e2c60e0f443ec32bc08e7abfe681e25ca9"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ffc369898100db5b06e87ba45cb7cc05e36458981a745968f9fd1f921690c19" => :high_sierra
    sha256 "5439dbc65397ed0ea20b336204ad1fc844e35b991b9e4fd5c30bbe31de42a9cb" => :sierra
    sha256 "dd0338691529ceb7b2937682593981d1012d7c5ae2debf3dd19ce647b9a17398" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", buildpath, *std_cmake_args
    system "make"

    bin.install "bin/flatcc"
    lib.install "lib/libflatcc.a"
    lib.install "lib/libflatccrt.a"
    include.install Dir["include/*"]
  end

  test do
    (testpath/"test.fbs").write <<~EOS
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

    system bin/"flatcc", "-av", "--json", "test.fbs"
  end
end
