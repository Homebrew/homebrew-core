class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/refs/tags/v25.9.23.tar.gz"
  sha256 "9102253214dea6ae10c2ac966ea1ed2155d22202390b532d1dea64935c518ada"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12c20ee066c782a075395a355739f7cfc74cee802f9cbab570efd22a5b5c5501"
    sha256 cellar: :any,                 arm64_sequoia: "6b614b29f088a1076e57e91fadd2c185a280c237ff57703665b0e4718674d9b5"
    sha256 cellar: :any,                 arm64_sonoma:  "d204e154d568f1776be2d1f63342b3ce7b2ddf6555909288bc3713b6cc6b8d1d"
    sha256 cellar: :any,                 sonoma:        "d409f500eb36584666eadb75b3f37957a20d1ddff9ab4833ced4e6f602c28244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a10152c4397535faca780babc41557d67262f4740f9fc21ee300dc69a9b16555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e494f52eaa03e3aade7064d96f82f64f0abe7e294e9b788821c894618cd4f7f7"
  end

  depends_on "cmake" => :build

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
