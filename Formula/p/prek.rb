class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "a142f0195178ccfcf192faf3f41487946f6ef148e46d35bf35c7e85688eeb259"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "912cacf363190c7b410bdba2e349662807c622edaf917c2991c8a05aade95aed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cff4b2a2e5c7e9515daeca93485b34c6a77c8ce5bb2041aee5c98e7d2374480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ef6d9cdff944646b2535a191583ca2acf92b0bd347012e552dd05227b1bbd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "900c5ecc102c1552e2fbd09e7fbf0f524c8789b6f47928b544e6f6092306d7f0"
    sha256 cellar: :any,                 arm64_linux:   "508b9453c2eaf6445a5761024a31d60664ce7d2611c5c918f51fe623611645bf"
    sha256 cellar: :any,                 x86_64_linux:  "0be685485cce41d5d799fefb6177c87b5476924b9b1d906a11f3821000ff88d5"
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
