class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v2.0.0.tar.gz"
  sha256 "9ddb9031798f4f8754d00fca2f1a68ecf9d0f83dfac7239af1311e4fd9a565c4"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a127e4a829de86f314a3990b9d85bf14d854bb682e8f8e32272990095b2b654a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd07b2efac10b35609da3ab52c9549d360c6db6b6193d5b916dc5eb98c27267b"
    sha256 cellar: :any_skip_relocation, monterey:       "ccc0b4894dcef07cc2f7ab8b08822b0d32b418e51caf1f091dc58260f73871c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5a82ba1d1ce4c4b77053bc294af6a5e6094c5b7e59e4b4c946b4301dd71b6b3"
    sha256 cellar: :any_skip_relocation, catalina:       "149eda4aca1b555fd228e9edc2bf4987eee46e0445ae1bff79404177149e6f72"
    sha256 cellar: :any_skip_relocation, mojave:         "3827dfa116cdaf777f7bb5023b3eaecb2820265bcc57dce833724f84d2c17065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcaa60b345226421198d8413ba4973db4d9f56ce471c6e95a7d50e0cabee3f9"
  end

  depends_on "cmake" => :build

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
