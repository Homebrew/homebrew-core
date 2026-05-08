class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "3bfa9e8ddeff7733b83cd2e7c96842c383aa922c9d8f8e683f7e67e63808adf2"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cb113bc18e3f9c94e0f2a42add59b683aee315669260871020e6ebf9ff61ad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "832ac1bb72754d0b300b440206eabeea1dd24dbab258d61224e6c7473b5c6d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17be59ab4a3c43ffaae0dd64afb9a55d4fc295152075735bbadb43fe3ae380f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "234bd702d96c445688be5b31d8a90e8c1f78aa82d688217fb3f40f890c6cbd03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f3ec9a34c04457cef6adffe8faf492ad20fa25f240667dae9a28b0b4140c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d21f3c62210a7b426ac3b667300922a4b68b592d116c8d194a97d0db347ed2"
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
