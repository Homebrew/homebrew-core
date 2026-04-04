class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.8.crate"
  sha256 "5d1475c16963a11ea5ed0bdab07edbc55277217c17ac2f35a5ea4dfdf6a82c6b"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15f2bc0035fade4c6a4e1bb584e05c89394eab46b1c016de550ccbcb12102e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e02f2c6a26aceebb92af8229ff5ac6862f60ef570c921e02b0b5bff787d3e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d190cd166f40635ec5f36ce925511233846f61e2ab2e4247a3c1e3c2321b4230"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb79e406763b8dbfb2b2fa76589a90e91c22a2650270eb36c8b069e4203bad75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07abb96de2830e4be7e28acf500c974c3f6887bdd30cad71151a8a00a1c48c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2eee8281ad63b468442497ab3a93ae79f2296a767019af01ee929dd128a2ae6"
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
