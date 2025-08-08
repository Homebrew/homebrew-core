class Prek < Formula
  desc "Better pre-commit, re-engineered in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "7d3762bfa2c300d120cfdda0059e1b24ccb254c6174186e4c2c0ab88284a3cca"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47ac7a04e1feef9d204735c6f904b628361b9ab8884c0216a8c1eb00d7145200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eb1bf86fa7d6e7dd03383bb7682db0b1de305f576812fd29c5a421fb291bd80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c0e8b57946f6a6b531792f4cf52e1204f1ca2bc67efea9d5328cca3b135c1b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "df78b980eaa539d815cfc401731d64302caf1ad0ed1f583f495454751247f43d"
    sha256 cellar: :any_skip_relocation, ventura:       "91acee00d9d27dbda3db07479c9ab32033990235da6b850afc834df85894cdef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3656cce25d3ca9a77ee5f9ecc9b6a3442e510b852b3b16babf211f334cb0137f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "376432c96879ab3e082d453c7126c2d7d40d1dfbe56d09b4ae3be54eff0cd0cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", "generate-shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
