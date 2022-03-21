class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.32.1.tar.gz"
  sha256 "7ae284d7fd954879a598d60afe925020f34c0b522f62f8d8bf8d60ab2923e628"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8b991cbb16711f95eb647d8cedd67507d7b9725fc3fc2193f33fed417d5573a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b86cbd5b42e7e40fae297830f07d9f127602fcfb1c9d068d9dfbc552bca0e18d"
    sha256 cellar: :any_skip_relocation, monterey:       "c19b0aefa325ca9dc7b2feb47313d8d604e1d200d50651bf9199cd16b113b460"
    sha256 cellar: :any_skip_relocation, big_sur:        "f182cbab6de1dd10af39b98653185e5ac9d7b54d58b6a627732a5eaabd611ce2"
    sha256 cellar: :any_skip_relocation, catalina:       "be621e00342154bb70966be25e37d6219223ebe9f1fccc78e37a8202ece41299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4e8e76dc5b0f597c5d9ee45b2472b37e13fb673355057eaca32eed985c889b"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
