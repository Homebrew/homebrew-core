class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/jj-vcs/jj"
  url "https://github.com/jj-vcs/jj/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "1b8f6bdbcf8e53d6d873c8677154fe8e3f491e67b07b408c0c7418cc37ab39ee"
  license "Apache-2.0"
  head "https://github.com/jj-vcs/jj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "567fc751812aa773c886329a89d3cab7670b1479d42332c50c45dc3be4100860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8885660ce096610d3b81c6671eedfb19a4f022a64cc3f2b56b3b6c55dc468733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6466fb832b6c3acefcd3a5ce8a578151e6badbcf71a86a2cf575a38c18ce3ce2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86a3fd20ac634bd7f0e29c5fcd888a4c7d3e507c443e208e9e3953b861083f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c6cacd4679606ed26bddfc94df59fb0a6002add4fc8e81ab0a4bb9001d670e2"
    sha256 cellar: :any_skip_relocation, ventura:       "6f3719f51380774665e54bece22995def7986c81bce52c1c11907bc7447ea073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1975f55cec146d76cedf3062978da72b3b9ac7e5006adb6fb575bfa2b65a8cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44bfa2bbf12d4f03a4747edaa0a9425abd51b8b89d5b8d2bc2f3d3a8be6cfb8e"
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
