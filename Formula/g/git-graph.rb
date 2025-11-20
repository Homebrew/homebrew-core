class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/mlange-42/git-graph"
  url "https://github.com/mlange-42/git-graph/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "105980d19b93324e27ee714abde35cb05b29e21d3c42cd972afe4d4500af05ee"
  license "MIT"
  head "https://github.com/mlange-42/git-graph.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffb5b63fd57b8d6c42b411b798a1ed26701d83c83f5f2765ae4747d30ac55075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d6c08af20fb91b65ed8ee52339e0f6d1084d0c59ac39100b083c353dc40ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b30d7039751657bd5b2eef0ab77af8b71d8b5f4819740a41ff453af7a4b45d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "741d421232f892435a536b536d6830317ed260a3af9ef63c8307df49c3abcf5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89682f79371c557999cd19bc52d5e97fef81037741a7c0a25dcbc3d848058d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d135f24b19fc8d89d1556fd3f8d6d6e0f1c01783339de4cd6a31848fd55cd99d"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-graph --version")

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"git-graph", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
