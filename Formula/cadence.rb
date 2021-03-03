class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.3.tar.gz"
  sha256 "173e6e4d33763bf5847de7074815a0d519b4a0a69a5f6b0fa798efd7f3c43158"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3e9b22888ea0bd37c6a64960d26e43d9f72bc4e7a0fd671c32615a86a722519"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d877bf9bfbd4ed4e413a42c02ee19661b6aa154685d46052aa42d748bfa443e"
    sha256 cellar: :any_skip_relocation, catalina:      "f69d6f048617b7844b588045b71100311d18f47da47e4f6013c998f185a60b96"
    sha256 cellar: :any_skip_relocation, mojave:        "1c73e1639d5da3b740bc4593b173741fbec0fc8a7aaa7ae29d0a9230abbfd77a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
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
