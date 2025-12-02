class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "bd7c7e46ba423cf135d26acedb1cc61c66770b353397017bd8fde87fe8c4a2ee"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2634f237edfcab7880f95cabed25f7c4369e9b66818d811d7fb7f777fd04f6e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335857b6ecc51394ab2d53bc31b5a2109e13e8f2b14a487addf5a392d12bb551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f4ab2541191cbfdd658a11584fe38befacbaa9cfad40878e4e32350c15af2fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8536bafc6341029298e846d31bc8eb45a6bf5d21369678ebd89d1f6d90f1ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff01471102fc9379bab52e6e9504f51d9e728ca45eb8990b3c0fbed773766de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1c08b6208c87e5983830829d2c29f78ac0bb2948b57d86b82b2866bb8b4009"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
