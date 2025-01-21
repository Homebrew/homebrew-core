class Planus < Formula
  desc "Alternative compiler for flatbuffers,"
  homepage "https://github.com/planus-org/planus"
  url "https://github.com/planus-org/planus/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "deeb35ca7db3ec0126a9ccb88b7db2d32a6aa1681f31719c0b061508a6ad2627"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/planus-org/planus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f2f44196c4ecf6d8f6af707acaec708fb11672e7272c64aeb982acf2428a882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a14952c5a270fa20c60213c43cd5141b948261e282f903cab5c8901d90801e95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f9f34194fac099e18356c098e93bdd9699219dab0316c0550cae77e0fbd3ea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4a197cd3ee25d5108bd20ac2baa34a7a8b6e3a5f26fc072c4e872b704786ee"
    sha256 cellar: :any_skip_relocation, ventura:       "5834c12f26403a0c54ef8ba1052247d7dfbac4c9f44b6b56cbed6120c871999a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00fa289dad3f69131943019476ad2f475e88031193ca8088c1364722fa206695"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/planus-cli")

    generate_completions_from_executable(bin/"planus", "generate-completions")
  end

  test do
    test_fbs = testpath/"test.fbs"
    test_fbs.write <<~EOS
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

    system bin/"planus", "format", test_fbs
    system bin/"planus", "check", test_fbs
  end
end
