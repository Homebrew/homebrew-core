class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.4.2.tar.gz"
  sha256 "2e42e5ed6ee152de73ce1f32f2e96d2ebd77feeef8c1979fc1d8578941d07ab4"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5abdb406b83a95f298035ea6d738e88568a8462cf738ffa203cd30ece578d48f" => :sierra
    sha256 "9637f76e7a3b01c5f6e69b73752f40b8ec2a0d0f353dae6159cf54c82258fe84" => :el_capitan
    sha256 "4ccac91a15a9cfa05bd707738773f69bd69011b3f700434d1ad10c4a8530477d" => :yosemite
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
