class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.5.2.tar.gz"
  sha256 "02dac93d3daf8d0a290aa8711a9b8a53f047436ec5331adb1972389061ec6615"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d56ea23dbff6621140be7b5b3c695f4299ea4f80c6367722061de683281d368f" => :mojave
    sha256 "2a74926d42d163e76d31908d093317c6f7358c5ceb6faf484d1ee091cb390007" => :high_sierra
    sha256 "99ebf3cc4dc5edf37bbe8818ea956f232acdfc377e2cfab162196dd12de9d4a1" => :sierra
    sha256 "3e6f7152a819fbc51617d77e626ce63294f613d92283af384534639adac01970" => :el_capitan
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
