class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.3.3.tar.gz"
  sha256 "14903f53536947295214f7c1537b6ff933565453a440e610f0b85c3fb3fe6642"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dc5c3a71134c23a9e401dc4411ea161c7e9e766ecd263ae5ce0fc09f8f623ba" => :el_capitan
    sha256 "0c5645b370f0b76f98395b6ebd1ebabe28e2f1e6b004f89aac48c43436a0c3f0" => :yosemite
    sha256 "5dae21daa84fa0afed9e5e740361b58300f602e6cdecd3d21c9578d6fd71759c" => :mavericks
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
    (testpath/"test.fbs").write <<-EOS.undent
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
