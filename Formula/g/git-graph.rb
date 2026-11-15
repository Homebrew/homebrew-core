class GitGraph < Formula
  desc "Command-line tool to show clear git graphs arranged for your branching model"
  homepage "https://github.com/git-bahn/git-graph"
  url "https://github.com/git-bahn/git-graph/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "9c9097b7dfe113e5ec50bbc623c85922f82d070d5f42e2116ed2d5ad80162a9c"
  license "MIT"
  head "https://github.com/git-bahn/git-graph.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29794bac9844c0a4961e6da18018387b4c55c2f54a281224b57c7e654807940a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fadb365cd2b141445e372c3bebfb3524ea1e6a2fb93e5f13a78796a85afd1802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b993f1de711d7ffc13c87c7e4b6ed503dcf57176dfdaf4c0ac824f7be43e6f6a"
    sha256 cellar: :any,                 arm64_linux:       "8284865603884f2d9068fcafe36dda48d3e6d33546b3424b5742324c7a8f68ae"
    sha256 cellar: :any,                 x86_64_linux:      "af504cb499a38b38021cb386a5033a5d3c3a6dacc8c3545dac96d8dcf0588572"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
