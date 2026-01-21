class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "9721d80a23463bfb6275c6470fd7d0d91ee0167621f4a9d4a7d9a7d850663af3"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b7d89fefb66075d6f2e6f5be178fffa0a776215fae2d892aac7f142f07302b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5470b1c4062c4c4bdc8b7340be4e6975b991636c7f851e73a45b56d8ab838b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14b8a4763b5f76443c3e0d38dda94847707fc12ecd62ba6290ba2ff368f48955"
    sha256 cellar: :any_skip_relocation, sonoma:        "31adabdf941ac01e6f13012fd51683f9818e58101d3f799b140ed4ae367b2ea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33b57240bef7910ef3512c42e25e99c22144fa53bc3432a01215af255ffdd21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b868f8abc7c5e04e47376b5ebecc29f7c48cff0250c41b0fc695517d5e9c8b"
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
