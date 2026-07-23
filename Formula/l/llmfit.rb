class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.6.crate"
  sha256 "b9c47c1153f87271f70e4e86656be289dabb3b557c87f3fcb4881ccc2747493e"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5318ed384be41449167239fed01667c910bab1df2dd86b8d8e087335e193156a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05ef41e2e387ba8d05c327232a6ce9ef1ddca84a9b0a10d074babb665b3a461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "424a637fab865371e0e4516bfcee159a827007ca91b94ba15c606158aa71aae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e4f2c1dc3aebc932ab90a2d839855ec4a3568808648b6c21cb51a1beb03ec59"
    sha256 cellar: :any,                 arm64_linux:   "9e86f70bfde897386cf9bc92b813a67b9249801f90c2dcc24ff2384faeb66507"
    sha256 cellar: :any,                 x86_64_linux:  "d4a93118269a6e388b4ccd12e5f77f58ff5a7ef1a9d22f86b98d17dd925823af"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
