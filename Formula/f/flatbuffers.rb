class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v25.12.19.tar.gz"
  sha256 "f81c3162b1046fe8b84b9a0dbdd383e24fdbcf88583b9cb6028f90d04d90696a"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "328b035addba1451d382b7df88101a006f38f4f148e41b3cf37927139e4b7926"
    sha256 cellar: :any,                 arm64_sequoia: "7ff96ca0377f7007e2b7476ccf5d128f8ca1e4f1ae48799c54c4e3169f47da65"
    sha256 cellar: :any,                 arm64_sonoma:  "9861b60f635fbd2b053d9e44d6693f28066f674602a6e678a6810b389627f0ae"
    sha256 cellar: :any,                 sonoma:        "4f9b13c5ecb225cea16d5c60ec050933f6b5f76bcb08d9d32f7036eecb2448db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94a3da2f6d6349bdbbac53f0a8b17c022ff0cfb163029dfe589c4793198445d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e4ccf9797920f3ecfbbb9a5a540b1416f377d7a7b04a851f23860427df1434"
  end

  depends_on "cmake" => :build

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
