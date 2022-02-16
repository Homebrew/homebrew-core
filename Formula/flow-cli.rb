class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.31.1.tar.gz"
  sha256 "42dff476e0cf40e570851eb9c7b3665a177e5632409fb8c980a708f67775d508"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a9b7811a4e6d01a0562cc22bd22af7a5f94b428de4528a218c2ca60afffdb44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9879a501bdf49de308c1a68a55655326c55313cb354d85c28192cebf93346212"
    sha256 cellar: :any_skip_relocation, monterey:       "65317541f65d8a950442814773f2bf2743a2141b66460cf0a456a7273d914a8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e235afc63fb5999f600c20d729d9a6ec0914b4d6e22752b3bbaafa24529c0173"
    sha256 cellar: :any_skip_relocation, catalina:       "cb7d72d4529f8d4dbf085d111d2ca3102d39c43af24a4af10876c76fd4b8323c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623d0ae62cb14c73e639b3a9d4c121b5155e040ddc82ebe5e9508db06a80ae7c"
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
