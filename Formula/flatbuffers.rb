class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v22.12.06.tar.gz"
  sha256 "209823306f2cbedab6ff70997e0d236fcfd1864ca9ad082cbfdb196e7386daed"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8da20e54eac4faa2871abe2bb8f99b183b25083328adf2b9d1cb262a69eac57"
    sha256 cellar: :any,                 arm64_monterey: "f844a16cacc5c337ce88a1afe6f7fbea2db98c63a63085281c47da9337decb3a"
    sha256 cellar: :any,                 arm64_big_sur:  "96264bfdb14634ef2712397b2bbcbc5c98ab54ce82ecc8d49aa0b520b394b883"
    sha256 cellar: :any,                 ventura:        "65bb7edad4778afe70173c252d40363af4e8fc71c9d1a4ec42a92b314f92114d"
    sha256 cellar: :any,                 monterey:       "997d22279049f9e39844c80f316f72a169a8d5d13e4a5e796dd49d4a8f98a9f0"
    sha256 cellar: :any,                 big_sur:        "b5a652182350c30e246cf7917e92768ef6e337e013d83f7d01091ffeb6dd3610"
    sha256 cellar: :any,                 catalina:       "9b6835be6c9cd1b624b3ce93ac85b9104e27c0ed49b91b4f40044cdb18066195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2cd1cd803dad119d35e41536ad16ef89e92561d5ca830215c46048f76c4e3b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "osrm-backend", because: "both install flatbuffers headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DFLATBUFFERS_BUILD_SHAREDLIB=ON",
                    "-DFLATBUFFERS_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testfbs = <<~EOS
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
    (testpath/"test.fbs").write(testfbs)

    testjson = <<~EOS
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
    (testpath/"test.json").write(testjson)

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
