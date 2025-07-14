class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.19.tar.gz"
  sha256 "3823fadaf15b74bbbb586f8898da6526a4b9abbbe911eaa032f268d8a84b0b82"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68b78bc5c7204d17b7821069505d77638c6bb72a21f528396cd08f2823e1b977"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52117a6db7962f58c5a97db45c1ddedf1a79942bc9d421736536640b4fa6922a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab54c81fc6100ec406b35ec45f8860134a1f66978f9aabd38771816d92cb0bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f99a26e9f1b590a5ddf6a8e16473113f367c8bfe2b320337763c1b1d1a27793a"
    sha256 cellar: :any_skip_relocation, ventura:       "4c31965ecd7a81b3795e99b57bb3268d80e8added779a1483f354f63431f86da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001a0e274bbb328e227efb024dc6b5a9acc36773bf0c78bb6f064f8bcb24dfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aedd49ecfc15319d0ec8df9918b58d85ee6a77ab5ed180f83358015d3254cd1b"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
