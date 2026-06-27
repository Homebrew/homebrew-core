class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "16126573633d4b1f1034a2a96ac7d628784e85ce3a82dc08bbd7301718259fd8"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0fdaf74500414c30862a9d3150d8c2aeda9cc1b0978c0cd0ac5824620293c86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c11bdd58eae18bf5772521653d17c6064eb2a0c4510c770f383863402d50038e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "615cd140847210cb919aa0d24fd9a4fe74e575ffddccb2db7e169b97dca6ad21"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e3a70aca35529927326928c8993de4b744e3cfdb1f4dd4abc62aa7269daa51"
    sha256 cellar: :any,                 arm64_linux:   "4910f09231cd99853d9d256aa438ab8c01d17157304cc49089bf7595a8ec57d0"
    sha256 cellar: :any,                 x86_64_linux:  "21a8fc60b150ae89821aaf8ce4f178afe4eaa0ec377309d499490aa16fcf265f"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
