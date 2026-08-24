class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "6f0d3615690382d4a1339a81a2ada2330ac5141481eb79459ed8d63026efb9a0"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3d92eb3168595f5279080ce37adb3ef33321c455ca119dd3f49d520f62cfb3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c5745e84841143f8203304b5a3ac36d57b5e1d339af6106300a245484aa9132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8da279b2ea4287c1c248caa2c6f7a92d979dfb9b8c4a87f56ad5678fd6309a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb54d34352cd55efe70ab499bc232970b995747c0812d0eca5a8870d8026d4f0"
    sha256 cellar: :any,                 arm64_linux:   "23e1290e031b54e77141747e2faec3d14d823eb56484c6e52a5dd0b20f444465"
    sha256 cellar: :any,                 x86_64_linux:  "36bda3ede820778930431ccdcb37cca2fd9d7864084adeb2d6c9992f76305433"
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
