class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.6.0.tar.gz"
  sha256 "a92da3566d11e19bb807a83554b1a2c644a5bd91c9d9b088514456bb56e1c666"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ca5ad18001cd6511efd9e6eca6b7c4be094c276c6febda4961ef9eaaface955" => :mojave
    sha256 "b792b08126ca76b61e6b0957b11e22118138cc698b8512169bae6d1a6a1f3213" => :high_sierra
    sha256 "c5eb2a9d90a410ba1807b3033c44b988c7e494dc6aa5130052c7bb57b6d1ea27" => :sierra
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
