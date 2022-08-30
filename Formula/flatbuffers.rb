class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v2.0.8.tar.gz"
  sha256 "f97965a727d26386afaefff950badef2db3ab6af9afe23ed6d94bfb65f95f37e"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4273d6223ff753501784c64c2048cc876216ea348b18f6890d0233bb6f5a3eb2"
    sha256 cellar: :any,                 arm64_big_sur:  "beff22245cd0ff9f648b566f7e20bf397c1b954c5b35474392fc5f91ffce865b"
    sha256 cellar: :any,                 monterey:       "da9d10bd95796d269f4911cda927d38c93a0e357c3e95419450d9d06da68ed48"
    sha256 cellar: :any,                 big_sur:        "b2e98c4e93068ca3cfd73e528ba82b2c5e17cbed9e74570d5f427ebae46e5940"
    sha256 cellar: :any,                 catalina:       "d624797c773abe5b1681b5ee1e47aebc119ef1e121babe00ca5e33d359d06b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2997a1ef21af93fba688c0cc257080cd3832e0bf3f9bdcdd1ed6d9929a01091"
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
    def testfbs
      <<~EOS
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
    end
    (testpath/"test.fbs").write(testfbs)

    def testjson
      <<~EOS
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
    end
    (testpath/"test.json").write(testjson)

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
