class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ed98928f0d2cbb7ef716c64d86e32f24a17fe0924559ea5a7bb786383b0ea5dc"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa8a3bedd1e28aa89c09833c28fe86390c14e6e322d4e8a8289b431bc6bc3d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd3d59fb819215141b25ddfa6d36b079361832969ab6381187744dc318be84ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81da5f8007d3a3fbee59c96d58299859e095ea122797b61ece53280fb29b3fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca60bc6c5f0b5fea7d26ff02861ce774799319f1c304e5358cdd2591fd9733e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82131d7f63debebca8c15bde7d9a803c058003380cadbe9164107f084375ed11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f42003d2c4106993c55a964f053707ae11d22635b8c4344680d737112922c101"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
