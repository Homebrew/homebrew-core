class Planus < Formula
  desc "Alternative compiler for flatbuffers,"
  homepage "https://github.com/planus-org/planus"
  url "https://github.com/planus-org/planus/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d79f5d9a1acfcadc86376537c297853dcd6f326016f8049c28df57bb4f39c957"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/planus-org/planus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dba48be6e547ba8587b1817226ca0ae1f55641cdc1d6f2dd9c41c9c8fb1903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cb483d4499fe5f26af67e782d259a6177668d94189c234f583a61d2191c41b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72c79d7843232d9129eb468d6754bb7c3f01743de385b026b83f83f815935199"
    sha256 cellar: :any_skip_relocation, sonoma:        "b447d497d16a77f75046ec5e21dfd4d460a89bfa80d59d7b66cfb78beff0c917"
    sha256 cellar: :any_skip_relocation, ventura:       "e211abbe537766952f09d5d299cb0e07bafe15d274756ed313416734aa1c2203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9ef40ac2f198d20d28af060fe9ba25e7a7e16aaac08a0b85a23ff1c362ae0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01b73a1936dac8940d36d78673f5cdd9d8643981b70eaa71afc2c38256904226"
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
