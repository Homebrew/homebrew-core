class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "c14bfbb5121c24421aea5fbb91a9c835e3e3372e53bdaeb3dedd87cc8eda56b5"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05d9c234e51b489277abd06672c5e5500ed36b863e77141fe4b047558ead363e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9fec3459ab8a79e695b4345e9e0e516a0e711be585da7616e13efc527ed9f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "499ce4b27ae59901b7f35484a3fef561df3665904de3e0115ea263280d18ed74"
    sha256 cellar: :any,                 arm64_linux:       "351a06e1ba56e968187f7e80f420a0f32a42b59f322054c57b679da04e38337a"
    sha256 cellar: :any,                 x86_64_linux:      "12b16af9f28501afa0a0823387599cd01e1c76ff56a428fbf4b58bfbdc0a23e7"
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
