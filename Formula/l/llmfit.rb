class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "7fb81f4d2fa52a98cc13d8cdc4c97d3875420187f7c98bdce1b45755fa1f56db"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1299a3c1c217f8bec2946febc8644def2bf6f767abdf6d7fe1ca42012eb682f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95614aca5a045a32080c7bbbf6dcf991bb81487b544fdb0b4d8552e615172cda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6e57f0bd385042c7902e074f108485beb1cd7314abd462fce138387442e50b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1baf1cac6d3ff36bba7a0b4a92b27dfd26930098b3d69720f98c8f788b16b36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "994cea99acc2254bf3f9a7494ebde50c74907e6c9ca47c22629f434effa7b60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b35b5b06521d2f11fd82ed2c2623d12b5aa1e6909698a11c215d293bb335cc59"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
