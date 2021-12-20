class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.30.1.tar.gz"
  sha256 "8b90e5aa3d22114733e3b9c458cd51f6aab0b639778620e29b613f967c133c80"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7d8d5037ba9a6a21d2e6cca241fb058084af4b40acdda24893651d3857078eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eda8bfeb1e3e16e18789aa2b5edc070234c6cc81b46e9976aa59e2297ca4fa18"
    sha256 cellar: :any_skip_relocation, monterey:       "9907216cbb623eff67852565e0cec50d87e1ad8d8c0611377e35e2fa299e0756"
    sha256 cellar: :any_skip_relocation, big_sur:        "f37350d0651ab6954f86958906f802045b7f8768eb282cb4799217071e87ae1b"
    sha256 cellar: :any_skip_relocation, catalina:       "a8023d381a558ba06a84a399bb14ea7f44a293879210fe2b6f246c5a97d6f962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a664a296b713d9941c645684d049a638fcd4d6e3f4647922adfe1c00ad0c2e7"
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
