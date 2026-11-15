class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.10.tar.gz"
  sha256 "596e702c00a25a19dc25d7734ba56922ed6857252fc474a787fe271d0d42d4ec"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fdf2465ac1581547cf8ba9304d372bda8ca9863f0641e0c9a76052a5246012a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c2c05f36ff1a7a1eab38fe10095b9d46c0673738037bd505a5d57cc13a113fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc099df745edca51266f6b1527fd4a7c2ae61b149443f307bf442a25f99bfee2"
    sha256 cellar: :any,                 arm64_linux:       "e17897e2cd8c5d50f95da81d1443b831ff8776e98b0bc32a6a0561572e6f3c66"
    sha256 cellar: :any,                 x86_64_linux:      "66777f7655cf392e84c49bc5f4b05e15d188a1ccdeb5182a9fa0a5b3e2da7787"
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
