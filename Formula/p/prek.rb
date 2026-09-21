class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2de788f26f8f32691c848d6ce3345c7df632813b099a3c0f48f10f3b37866d7a"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c5cde2b6fe8bfb1c860baa561721967c083254b4a54d177343d468deaf24465"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b9162658fd208a5d9dba668cc868109299c9314ea1395669eae5202552191ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c052de409aad7938597fa279642c2266439115e0f8755dc0196a9b7a4c1fdf5"
    sha256 cellar: :any,                 arm64_linux:       "d3c5aca99832365f47ed30eeb087d7304018aaea3247e63a8d9347d6005459a8"
    sha256 cellar: :any,                 x86_64_linux:      "6fe9efcb1c5d226ad54e1a7fb283113e81743e8867dbcac5a4fa929171d187a6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
