class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.32.0.tar.gz"
  sha256 "bbfd18ddfaf5d64056f962d4434727cd7f6a2f70c954b10f955953dc06908ede"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e95aef135e7259bf773bbad29f88a9dca1b55cb8f482ce15222285d45ed32588"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7adf8504cf4d393637ec092671f2a21666eb5da84c56c051b56ec3898f5bf255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e52e5a81178892e050f9152d76b4e3f6bdf6ba5086123e8d9b3431f5a56760bf"
    sha256 cellar: :any_skip_relocation, ventura:        "5d0c7bc7b582958f407d98a587856b261a23b27da18f9283c618f878bfff1fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "8fcf5b9bcea0233a4f04cbcfca786c23df25999c81a83cb3cfa398d37c337009"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc56e06d82f2baefdbe74cf704350cb600c8a7e1bc5524758c1c59ae2bb83142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da63900f79461aae7a987deb80c14f1a64611566f8d62006ba91f5caa868955b"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
