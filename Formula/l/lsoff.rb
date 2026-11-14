class Lsoff < Formula
  desc "List listening TCP and UDP ports"
  homepage "https://github.com/yutat23/lsoff"
  url "https://github.com/yutat23/lsoff/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "d6acf3cace6fce7d56e02c3310023fb9bebf82d8a99ff672f1c4270141c25641"
  license "MIT"
  head "https://github.com/yutat23/lsoff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a0cbdc5bfbcb757d4fb28eee2e440c9bd7d162e82d8b4472e6dd6814fa63b7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2cb80727b61a20382d3f69d4b1b0c50a94be629fe8db7c148cc23020269d8fdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa187b3a13a4495456a2ac662caab84eeca355a3fd9ba52f97ed3462235b9457"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b98ba82176dfd43e00ed2de60c98d637f45639534a7d0d1315257bf8e8a7bc21"
    sha256 cellar: :any,                 x86_64_linux:      "98b35b96e6523eec0db52986490ce3d1e042abcc0fa2f2687d69c9ed76e97554"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lsoff --version")

    output = shell_output("#{bin}/lsoff --kill 2>&1", 2)
    assert_match "-k requires a port", output
  end
end
