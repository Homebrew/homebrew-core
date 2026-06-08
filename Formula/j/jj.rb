class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "ee495c2853bb2bca7403215e8102cbb9a136a73e18a9dfc07067789d38e14efc"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "026d7ac6d1c850d51d98031ed7ce35bda2ccd9aef6a71f05bac73da873f0c92b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338707e92d3f862f457207bf82d1f3fb9cfadfb227d82270481f360a830adbe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38db2f5883e17d567c4e399c6eb19026981e0148892ada355c06243da6e80c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "146e3b5284400b75542574fbef74f02605f95aa74647948cf162193fe76167d6"
    sha256 cellar: :any,                 arm64_linux:   "8b6c572836d6f9f9dc66e1cc32521b1c44c0d30691ba20c71ae7985d6212b490"
    sha256 cellar: :any,                 x86_64_linux:  "6c5eafcbae0d78764c3b422fe1c1fff93d4927716a28c80d8a846c3bb73477a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"jj", shell_parameter_format: :clap)
    system bin/"jj", "util", "install-man-pages", man
  end

  test do
    touch testpath/"README.md"
    system bin/"jj", "git", "init"
    system bin/"jj", "describe", "-m", "initial commit"
    assert_match "README.md", shell_output("#{bin}/jj file list")
    assert_match "initial commit", shell_output("#{bin}/jj log")
  end
end
