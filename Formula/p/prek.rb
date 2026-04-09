class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "fdca3ff08b10d4d8fc3dc820c704eb32f32bc838bf755ac11dbb8ae182fee774"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4998f20ee2577031e5e8c28736760818ed70a10c3f750424d051dd139034fd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75741ec3c5d136554ded5de36656ffe6cbbbc87f39b6afa2026d20c885bc29e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a9879b2f5002ace6254ebaebaeeae95620cc2e71d3047628fbfade85768b2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "033d8738b3b203150382ee653a3d174f358a4bf58ae2583d2363189e4cbb9c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98af4b29821b0c60dffe7d8a540acf85283e880cba907aafdae35159898dcedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f3f4d747fee5ab6767a227ed605ebb17805f5f9cc623481d5828a6f38d25f3"
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
