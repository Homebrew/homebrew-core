class Planus < Formula
  desc "Alternative compiler for flatbuffers,"
  homepage "https://github.com/planus-org/planus"
  url "https://github.com/planus-org/planus/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b703a3ea88fbe6e5afee6b190c85805b589512c6ac56c0a1e35c115f4cb96bcc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/planus-org/planus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5ab71bb5933d69b94775f87ce68ed005b5d7e99806293143470899c29bbe1da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4287cc939380dc2981efe6fe7a4bb04547befb1f8e9c799c969bdd7a8c0c73d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc5e42cbcf34a7c697139d15ae73522eca8e015e4a0c3cc4830a6a1287c12789"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5a07d91b93984e48c0016cb00cd3d3e7c91fb7278800ca7d198d15c2faf1b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6942d3567cbfbe52c0eae99322703e1c5e6ba764bbb537a4096fc0fdf561cf97"
    sha256 cellar: :any_skip_relocation, ventura:       "d49b051a620f3e1779b80028980eb4a91382a1fcaaa491b9d30c39e24b2068a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a878c0c743a78b1f7d64ca438f4bc66a6ffcb5623bd5d19499f5b29fd5bbcd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e676ce06649a60ccb6c6c4236bc97a10cb2196348ee54628abe49f942b8e35cd"
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
