class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "906fd9d019e6955ecad93e55c9497c39506f11d3bf4f2bbabe394a562caa91a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a6501122a077d569185475fa6ca7b1f1c3a6e87b68aca00d88fb5ca7f2f0e43"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "449d1e586e028059f2151d78cc7a73ece586e74e13b1b59d10f3c4dcaa85d5ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad5d55574b1667794a4f577c472a92a4fa3a04a3dcaceae822ff41845eb2f102"
    sha256 cellar: :any_skip_relocation, sonoma:         "43e461f27056cc7febfc4d5c608a3a439c63fc70d198b7b5aa5dafa62161051f"
    sha256 cellar: :any_skip_relocation, ventura:        "516a6e763b5ae82a55216e5fb773dfd973d4746601abf77ad718009b71f376c1"
    sha256 cellar: :any_skip_relocation, monterey:       "32899338ec80e9c6a6cda20d5c47ae536da69e0671e15b5549b77bcfe6f016ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c05f627dc9c2eb8449d2380bbb9054b5ce4145219473766bae54b41eb6f549da"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _, pid = PTY.spawn("#{bin}/logdy --port=#{free_port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
