class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.3.4.tar.gz"
  sha256 "6ad97168aa02d0ece1a705428008a404eea89af5109d6e099197477fc08303eb"
  head "https://github.com/dvidelabs/flatcc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad27c09658d73c21304d13df2d53061b83abfda32271250ffcc05aa5c4bc8d3a" => :sierra
    sha256 "ca840e6e92ef838ed0ca704341e3528d864d73233ed67a19fea41a31c7de85ff" => :el_capitan
    sha256 "109de10f4f14367200e5feaddc5f5ee2cbf563c016eab1a3fc1de102015b8f8e" => :yosemite
    sha256 "93eb6be33456a5b22c0895def431d0d00eb2858124674eeed6a514ed7c5ca0af" => :mavericks
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
