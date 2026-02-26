class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "ca3bfc6a10864c7cc7bf69825475d4430bbf0976a695e66bf1d41e721d48aab6"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eaecf4d600e5f854cca16cdb996966d2cda5670a987e39a316156fd3fb30be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f734a4f122e19b7965b07bd33533980340d021f57318d9bd146a84019b944a42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e37d0e014a93bd1190edda9f10af499063dd09e2500e987b3a657f8b9d5271"
    sha256 cellar: :any_skip_relocation, sonoma:        "48fc2889a18e2ac82b67fbc04059b1307af5e4b3bd533ebc3748522146a0269a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2778226e5ec45f1e15a63e6a820c313db2c05a2c009f965b38dfd793a1b6712f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d32c178b15fa4eadc009d5c7929adf10efd6411b8443792e8d0493128f0f075f"
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
