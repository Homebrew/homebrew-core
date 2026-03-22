class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "9f39ea242ff680b11e78164e94c45f11d15b1fdcf1b4af2a659bbd43945315ed"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4bda2c82139e7226e3464f35f8732d773c8ef47578d6d1f19c78a95f51731d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b6fdb52890bea93437694ed166941cf26f98e1f8217ac8a61f948e444a6964d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "774323d8631e9f6f977f07a1855f1664e4cbf1fb5c41653dde5e76dc60899e6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda58c84bea95310b365312eb6184ef3c3551ad530209546d4f72ea639335eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "686faf15b3980327ec7e814be5558f7edc62b2c1ac1970ced9f17f941cb485a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4cc283ddbb3373e14e66858629577d3d66c3f8a206ac506d6dd9b03d3cec00b"
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
