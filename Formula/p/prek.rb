class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "b3affb81a468dee2394acda7d20f9b08a49452c74600b9dc279e36b770517a3e"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "742ed48cc787357cc2ca623d0df5e752379c3ac0aec63e7a59352bc758d330d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c96e5aa17506d78a1aecd86ceffddee62fbe2ad8b46acb9090958d3f80bbc47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a34261872eb5ec3f4e8ed5e761c3904633d906230991775daa9b76db2e04e83"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f00af4e2d404c7b88d2fffccdae95ed2f66bf74ce5da5263894dbaa2d6dd0cb"
    sha256 cellar: :any,                 arm64_linux:   "368dd551ebd28176ee190fbf695a80022b18307918576584813adc608fdfa35c"
    sha256 cellar: :any,                 x86_64_linux:  "26512688ac8b51619b271a243ec06465cd952cbdb2ffacc88a2715c053ea6a04"
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
