class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/mlange-42/git-graph"
  url "https://github.com/mlange-42/git-graph/archive/refs/tags/0.6.0.tar.gz"
  sha256 "7620d1e6704a418ccdaee4a9d863a4426e3e92aa7f302de8d849d10ee126b612"
  license "MIT"
  head "https://github.com/mlange-42/git-graph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5f7d0191b0da4b5253bfaa8a0fa23d1f522139847e1ad4f3fdff0ddaa77edf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68da7a5147f7fbd27c1d4e5e88cf4a51733194cf1f25d524b34f07db2e8464e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b9735f939236f6bf61169a00235a2916f1c81bc73315af4d06955223581a047"
    sha256 cellar: :any_skip_relocation, sonoma:        "6647e901de849639018e2db27aee4ef60872ca480304fc000af89a59bc8faa5d"
    sha256 cellar: :any_skip_relocation, ventura:       "e2faa7413ad945ebd3f746608ac78472aeba1660f287b7ea1fb43d048899a22c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c224d2af4388112bbe4e3ca5969a865e233faf9b8190ad470c1061ebc2b76b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5588907cdfe85d8e69d6fdd33c0ccc3e0f1688cb2f920d2ef4f1ca8f1e7eef"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "zlib"
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
