class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "1fe32ea1b83f8566faefdd978e74cf78ead65841f60effa20b9da480e7d73551"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "547b22f933875bb5a39fe9b64ce0e1f645c96a5e011f1e9046733d4f02c134bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac49e1d2d589571a0978c75f0d629e65fe689eef2c423cf160279f2b08470c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c99742223b81543e225db7e6b12924b62096fc0fe95509ce98f9c6e38d48cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5202932084616a6060645f4cf7224b0077fb27e5c6e80bd927e6deea33c918ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d8c0ca097856ee72f728714f780f2a4b14ed960545fc12020e59eff9bc30b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "248c7a00fa402cc1cddad8800e89a1bc10e1ffe08500ff02324769fe0039c79e"
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
