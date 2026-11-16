class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "1dbafca264151131170d86f1b36e642797469dbf0ec98d77f1110c65f1aa0eed"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "937cf1cc555b95fc9e485834b138f672f8c3f3bb67064e2e020ac8b393456477"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e308d7077e481d8fd8f42d1d972de5c47a50ffad775457851409c42b53ba7e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9eb93f0d7dd7cf645893b52157cb6bbbab21c731f653427205b61324f9f8387"
    sha256 cellar: :any,                 arm64_linux:       "b90c1cf50a76f57a716a7ecc109ae360136b305948d3026bbb2a9f8fd2b54a6e"
    sha256 cellar: :any,                 x86_64_linux:      "4ce09779f7e06f1dcecbde3ebf4c6f4044bbf757dff290762a05ceef656f449e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
