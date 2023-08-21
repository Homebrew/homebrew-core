class Flatcc < Formula
  desc "FlatBuffers Compiler and Library in C for C"
  homepage "https://github.com/dvidelabs/flatcc"
  url "https://github.com/dvidelabs/flatcc/archive/v0.6.1.tar.gz"
  sha256 "2533c2f1061498499f15acc7e0937dcf35bc68e685d237325124ae0d6c600c2b"
  license "Apache-2.0"
  head "https://github.com/dvidelabs/flatcc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "972eddaa32d08f0f53c2091e03c44022597883f7d8f9a5aea361d3f91959d795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e63b4e0e204f4cb7d8ff62a5020deca986b97321ad3059f11153ee6c70ac06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff1f00cc07f66e878fcb04c06c498eeb6b4f5c49d46ba40ba15461b8ca339974"
    sha256 cellar: :any_skip_relocation, ventura:        "4fc4cd0080030928d2b93324cb8c00a65be3b568ecbecc45eaf9319aae07c244"
    sha256 cellar: :any_skip_relocation, monterey:       "145f6bf5c92bdd8f374639bb559c7b3ed6a140248ace0b1d4671c4b73b90f70e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e88a66053e439e9c48f7ef937d14ff27a94a20b58d41c706eed7122ca592aea"
    sha256 cellar: :any_skip_relocation, catalina:       "09edd043ebbfe5f96f6ec1f972934daa5a85f425f2333c2914eaa45b20978b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800852160e2675ab180b1183d205daf90646f9e92c5cf3a9cd8ceaaf24c1242f"
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
