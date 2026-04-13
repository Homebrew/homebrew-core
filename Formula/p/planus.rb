class Planus < Formula
  desc "Alternative compiler for flatbuffers,"
  homepage "https://github.com/planus-org/planus"
  url "https://github.com/planus-org/planus/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "eb4f65fced93a1c04f14a17ff5978f930cf68e2026a0f24d13a214d045a920ed"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/planus-org/planus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5305b7ce3f3309166104fc02522883d8bfd22ae452cde7dbae926882e5ea7fef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71741fd531fb3eb105cb8a9873d10970eeb1d2cd1b270c1aa017e1b2ee9c15b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3473a2125c4c41b932c2b7ba40988f02a565e027f5f6d8bd1fe0e8e242bb2d37"
    sha256 cellar: :any_skip_relocation, sonoma:        "d88d632135ede2537474539ddd5bc51087b3582c3cf61ffe92821a757d2ef98d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e4437750ab00b286495e9947d79930e1797cf1f2121b06aadf6ec568d4ec261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "334767fa2e76bfba0518a882c5fb33e5e4a6cad3b3016365bd8de363a617eaee"
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
