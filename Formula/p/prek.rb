class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.11.tar.gz"
  sha256 "60695658e54faaf2ab2268480d09189e6bdc0e4ebdecaee7b78283b62a8646e5"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fbc25dfdb0977b0487fdf80eaeb2e5fc7655c2080ea9cc54010adeded4cb554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "895f2aad3b0d6bdc0d7c9c593630181c0fa705606a4de49cd03ec1e9e5429e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f172ba1a9199e66121a3b41ee93660340cb4e574bbf3dc14da9696acfe1d56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2333adbfb107947ae15d45ad080216704de4b0066f93532e11dee2ef35ed32d9"
    sha256 cellar: :any,                 arm64_linux:   "92b950ddde18439162b4eb713f38ea1da0c6644c38c7cff1975079753f1d0580"
    sha256 cellar: :any,                 x86_64_linux:  "a093e5f96da6e2c6f45a7df7e03891964a874e2e7de004ad38c25702bf1cc0b5"
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
    assert_match "See https://prek.j178.dev for more information", output
  end
end
