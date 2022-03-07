class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.31.2.tar.gz"
  sha256 "3ffaae8f48fa4340ed04ff4b7b753cb2a3560d29dde72a8f4c92586f17345a7b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4c23b8f7dbd644c2d002ded9558acd4f9766db1060c950f870718989234208a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9103529020935209d3b1ec0ae1732fef08eb2e1c8068f0a065b0b264f2f9d414"
    sha256 cellar: :any_skip_relocation, monterey:       "b24e57548e81127cf0de5377134c95fa3b1d33279338006ca4b34e8ccdb22eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "abc6dc1c121e29158c0fce1d8074d703df4d594235b606539813c37bc6748a30"
    sha256 cellar: :any_skip_relocation, catalina:       "500043c9959075e389b085b09ece98913ff316f4f9f2ed547fb4ddafbeaeb73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acb483308e3296157d4192160ec0f542397a5574f8926e718e448bfd1ab18bad"
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
