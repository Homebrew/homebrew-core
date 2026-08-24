class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "29db48a025bda2dd79399fc36f1d26516343414c0cf7d0b751b8add6b2e6181b"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "04812aec2e32f6231fe8ab2d364fd6d5ba278f589f75fd81dba66d28f05ae012"
    sha256 cellar: :any, arm64_sequoia: "9f012f3973ad5b0c9ea006dd16e36346073b8a2fdc9129100806533f706e10d3"
    sha256 cellar: :any, arm64_sonoma:  "6ae664eb8de821447bb69f380d0614fc67d13fd90f6ab852280900bac0df1ebd"
    sha256 cellar: :any, sonoma:        "dd197eb907f67c941f6651adeffd333bba7185b72f6efe257463c746436840c2"
    sha256 cellar: :any, arm64_linux:   "09c8f2c18b012718bf8df6fa2137405aadc7c8d325eb55b6ac073f3276cdfdf2"
    sha256 cellar: :any, x86_64_linux:  "a07bc9305668ce062ae98478c41b3ec31cb4e2558ec118fe2ef34c228e545c3b"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DFLATCC_INSTALL=ON
      -DFLATCC_INSTALL_LIB=#{lib}
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fbs").write <<~EOS
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
