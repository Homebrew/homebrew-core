class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/mlange-42/git-graph"
  url "https://github.com/mlange-42/git-graph/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "105980d19b93324e27ee714abde35cb05b29e21d3c42cd972afe4d4500af05ee"
  license "MIT"
  head "https://github.com/mlange-42/git-graph.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1048c932a8deab74c8eb90e4cdae3a4a4b63fd73f945607a85ae507fcc89a043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17350cc0ec47ea241a5c3a99448f0aa6960615cefb7bf83c639fe17a8a4f423e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43198bde0bdccff80d898f21481970b18ebf67073982e9c5eb1d1ddbd7ee3b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "138badaf5ce366f4c77866725e3b367eb706ba8d6a1d309c5e8d58c4ced62f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c0d6fd0d897f0ae8825a34463d50c764f5942c80c8106a255c5ae9b879261e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7173c050dfb74dd21608c3fd490921e68219491015baa161cf66153dea32ae"
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
