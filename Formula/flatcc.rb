class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.5.0.tar.gz"
  sha256 "ef97a1c983b6d3a08572af535643600d03a6ff422f64b3dfa380a7193630695c"
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
