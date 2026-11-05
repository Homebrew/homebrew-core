class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "838fb5ddbf474ccee6639ce68835cedf88c8285b5c812599c56688286fb0b7a6"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bdf1fdb8048642b31c21ac4f2fee317767f2510a30c25bce81133f3165365fad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8c813f42bb78caa6ca15b2da67b030d7007906795931a36f064aa8d42779220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "14a25cc452e53e2f34c7069ea2365e0e0d97d43e59ebf49c8d48f12978a69d63"
    sha256 cellar: :any,                 arm64_linux:       "b31e6a51b432ef36c54238bf2dbbdf319c4cf1ca257305b97f47fa659ec0262a"
    sha256 cellar: :any,                 x86_64_linux:      "e77efd4f7ecbb0986e2ab69c54f5d6629bad6600835a7102e6ac729d328c51c1"
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
