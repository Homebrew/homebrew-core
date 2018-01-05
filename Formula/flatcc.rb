class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.5.0.tar.gz"
  sha256 "ef97a1c983b6d3a08572af535643600d03a6ff422f64b3dfa380a7193630695c"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "32eb49e68c172e97d1c0d16afdcf9549b974e056dd5beba2e0fa6db1e542a00a" => :high_sierra
    sha256 "753161c52762b90cce67ed607c1ba7b23403131a9570c10c7b14730a91c82987" => :sierra
    sha256 "76d8d9eb8203f7c7c10457c3a4fe08158b484fd2d1fed9f35b7738d5ff396a79" => :el_capitan
    sha256 "bb34f60a5de4598d9bf4509f675b6badfe0cc03220677449157cb26f65fe81ed" => :yosemite
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
