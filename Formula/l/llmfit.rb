class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "06b9d6b6b3308610727d560eee44a89df2dface3919e677d72bfa4de7d11a4c3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06925c2ef4d631192e5ef50134246846084f12cc47a7e52cbd276080b2877379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aedb87028cd99ef001fbcec8bfb036c06473fc639da595d82e5165d72d4dcb5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9b5467afe78c415150d4bd31b88befdfbc9156ca3f130180fb5813f0d7da0f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcca31371130d84e0a9ca6446077d837bbf8c7756494d6b3aa3f34fd037feb11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4149e1871f2be74f86d93fb8f348c20d0d289450c70677a7c74af1466e78e35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f063c64c214faa93bef37b0735e7cc10f1579dbb2bdbef6e7178f727ed7116"
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
