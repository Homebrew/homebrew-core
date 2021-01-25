class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.6.0.tar.gz"
  sha256 "a92da3566d11e19bb807a83554b1a2c644a5bd91c9d9b088514456bb56e1c666"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc4f35c551b04bbca5e4b57b1ffb71941b9105a99a1dac2092a56d1e0f2034c" => :big_sur
    sha256 "3a3729b2b5856179197d13c36f684f08e4f4537a2dc6f7e77e49bbd826c86323" => :arm64_big_sur
    sha256 "f1f1cd7532305f48b008fb1f3687d9369a88f184902a8992fd77789410841b4e" => :catalina
    sha256 "74651142d2c732bfbe671d78cdcf3357189c9b3d3cb7078bf9e882ad9ca6b053" => :mojave
    sha256 "9e37511cd8069fb56ff15e72f0184d1908f9d4948ebd57d2b430c760cac60aa6" => :high_sierra
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
