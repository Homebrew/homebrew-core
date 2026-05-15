class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1b8260c0781933fb94e86a6b2b576fedcff60662bfee84b87216d38ada5e1cd7"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bb1dbf52d1e604c13b14416d63ead0eb868e7858e715157d36da2fefdf262e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81bbf2c0b64d0a6f7e296a3e014d6ad231819d7d840194f0a2e446aea24c786e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d094e48900f0ade47478e5089ad23ed23b8aae5d63a522bfca228daae0609ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "41ba0b777155acf0dad090a9dad3c3a20a20cb989e78464a1c5dd99b60ee0dbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86ef5f90fc38c84d2e1005c939a55eeb37923de59b8e63367ebeeed07ef3ef98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2abf3ebe0b4bb90f88c06f8d7b64a9b97bee24617e8cf485e2cb942e4ed095"
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
