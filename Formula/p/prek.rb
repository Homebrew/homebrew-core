class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.29.tar.gz"
  sha256 "812ae513cadeb8825e80bfc42771f3a55e75b12267bb1f1bb9f80737dfcb6c47"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "835cf48d4ac913da86d529701f8ac256665d318e397ac23d1f40a67d09c2fd31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e3bd1673c9a5623ca7332fde89c3d6604fd914682aba8a035cd1d142e7091c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70090d228fb52583a8d282dc81dfeeb88147f02c90e4f6f080dbcd14c52a3db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b9f55a4aaa1883a1cc210767e9b4942d7fc2bd825b6e930e91648be768f30d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b11314289acff171ec3922b58a59bb11650dcfc232ead8e80233158c987a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dfe5d41a4feb37f35f645af150c4a5b1ee2f925f41a2ded4abd74349a0ed5f4"
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
