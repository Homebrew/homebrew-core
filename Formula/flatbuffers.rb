class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v2.0.6.tar.gz"
  sha256 "e2dc24985a85b278dd06313481a9ca051d048f9474e0f199e372fea3ea4248c9"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bbae757302623a372216f106b93de53d5597f263521e43ddd1ef8a3fa280a20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602f63e1a229e1aa7ae75ab98e85c9925c133ef1f4c5fde22d8b9422505216c4"
    sha256 cellar: :any_skip_relocation, monterey:       "8c355d7efaa5cb1e3f5de82aa4846e14c05429bbe28bd84066c535d1241a034b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a72632bee30385a63c8cfdc6d2b8b4ee424441628b45f9171c15a8c646e7aec4"
    sha256 cellar: :any_skip_relocation, catalina:       "79b5ced50e23277d66e15dc30e71adabad35f8cc6e855fbcb3b3463c303026ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6cbb4603971c8c17ba98e95e428732c2096836eda6ed852180de2e34ac6310"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "osrm-backend", because: "both install flatbuffers headers"

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
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
