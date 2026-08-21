class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/git-bahn/git-graph"
  url "https://github.com/git-bahn/git-graph/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "906ef8f5931c32324ab372ac0047b6440faf76b8ce61fda811d8b85cdc3da577"
  license "MIT"
  head "https://github.com/git-bahn/git-graph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d218513d03440a2e708b1e0db2dd69cd3a65c05095c79877a00ecc54af02a8a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c60f5a5ad5d0c78a45a90ad885f0b7cd5e267a6b601bd4213227d782f29404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e3960271105a63db8967644c82b7921d42f3de432e89e051ef3bc1671d4de5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8baaad794c7a987496607a4800e6ead23a0e6cda613dcc48ccea6d3eaa9afa84"
    sha256 cellar: :any,                 arm64_linux:   "b9f8138ba429d8cf37ffa784e5f69f0f19c7efced6aaa74da5e95b1fcf22c711"
    sha256 cellar: :any,                 x86_64_linux:  "31f133c95d92f675c41bf6d5d0a44e342040f9bc3416ae50ab07fd66ee160007"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
