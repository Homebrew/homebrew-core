class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "6489f79d59dc4f9c11230c51d309dc9c6ec392921772b738546966c494b6d72c"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1aed89cfb22165a347faebdda3baf660c9680131adfd9eda9b3e917dc4e5aaae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f319ad2e140cbdbe4c060ee314045bbb7980e88e29d8e0da2989695e12c26ef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9a6b11959bc50a72c28eae67be0eae5d3deda0bd4cb0624252df121e7d60382"
    sha256 cellar: :any,                 arm64_linux:       "7232bbc3fb53615b6224f3d77c3dd47ed58f3f549c953d372fa11717ad94f035"
    sha256 cellar: :any,                 x86_64_linux:      "e0386a85e6dec74c2d8241dac6cfe21887740b3b186f3e58a89dec7a4248a460"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
