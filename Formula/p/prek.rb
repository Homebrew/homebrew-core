class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "596e702c00a25a19dc25d7734ba56922ed6857252fc474a787fe271d0d42d4ec"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "835a8bc0bfde8488bffaaa7a56d39cd7d2688e433b0c4dc12896ce343d0294c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05f9b34e5e15d64b452382ef2fe647be3492e2c219fce874f3cc1af82f5fa894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "672555dc057d2a04e98900253d51c55909f673f1bc1460e252e5152eefaae00b"
    sha256 cellar: :any,                 arm64_linux:       "c8c3e57fde124f382e8c0deba82be0ced97158d16509a284d37710cd444aed4b"
    sha256 cellar: :any,                 x86_64_linux:      "e4cdf595a2335580ceda49c85ad689d36a701fff2ea023972553d780e554e5ac"
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
