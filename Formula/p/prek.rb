class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "8c64c545ca51d7af781c19778f36fa022b5b73fe4c6754727230f0ea7bc71ca4"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd572f6346db17e7c14d1d075c45581d96e40cc749b51f6ccecf21cb8722a815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8a456bc9bb24ce9688a5053aebd5264e83cffbc436ad8fd41563851479e1110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402b8d088cda768f4b8c7e6e7e086cb8d6741b8926b87c117429d03d84515795"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec9b864ea19a5eb8e55c5ca57abf81489be84ba4578ded4308ba6c55096a961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cca6533cd52fe396975f311dd4d17b959341bf7b9c9e53e167ba01659a1adac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf504dd7101694e3e2c3ed1351ad9a3ff72804d6d9ec128e3d0ba68647c50f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
