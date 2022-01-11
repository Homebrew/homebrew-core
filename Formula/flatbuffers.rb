class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v2.0.5.tar.gz"
  sha256 "b01e97c988c429e164c5c7df9e87c80007ca87f593c0d73733ba536ddcbc8f98"
  license "Apache-2.0"
  head "https://github.com/google/flatbuffers.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f355a5549cf028d9fd0df696bfc16680be7837b30e809113fd35f8fabf129f81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09ebfe4c000192534f0a91f1aa5a25975315c040590bbd36fd22c8ea92db3732"
    sha256 cellar: :any_skip_relocation, monterey:       "84eaa16ae8f1d2399e2feb1c2599e4494d00fd1dfaf52e379d5c852e45142507"
    sha256 cellar: :any_skip_relocation, big_sur:        "41031bbb5ad0412bc8d837e2e09f24506cd3c5a78dc43a9932c6a9d1d66e67b9"
    sha256 cellar: :any_skip_relocation, catalina:       "53e9e6c3912b2fe2dc2e41efb7631f0ecf51a16184648d209efc1aa3bc1a65a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d530fd61f53dd077534c310d7472f24fbb5a87ba6825cf9e868ca6f8e3f661bf"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
