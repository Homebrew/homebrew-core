class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "22cc379f34c6d9e363d65f6082df763051eab87676c63b974916d1f06f55d254"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "784c48b82fae41440ec82e3646ca1908c01e1b9c71e61ce2fdb8b14466ca23ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "081dd78ba402e3fe2e2fe97652259dedab30724d277a1f9966dc5fb23912dc3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12bcce0847723c6ce80f1b23d4726791c7318264bd88d1280c3cdc16bed5615f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4abf2b3450d91506ede33211c6e4b340945d7f97ec21df7abd7495d15cf1bbb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17671c6ecf454f641d3b87fea1ddadcacf19b98908a125dd13b0bd1c56b226bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70230231fd5b5aa524b340ef29d701d0a6c4376ad9c46aa2ab8066f6a2114b77"
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
