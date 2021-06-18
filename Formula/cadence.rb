class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.18.0.tar.gz"
  sha256 "6739b8b79367847885a0ab0e51f3ee5b2018cbd270fe494fe9b2368acfbbf223"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9d20ce98ce3e604d28d8f4ab17668d69a0b77781c7bdfdd23d924dd5a938935"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b1470f32ce2aabd4f241e28f815a76b6d9e662a36c056f85f1abf88108457f7"
    sha256 cellar: :any_skip_relocation, catalina:      "f787493145faa01f69bed57e96aa09bd635e5684e98c48a3322fb2b45b636b64"
    sha256 cellar: :any_skip_relocation, mojave:        "c323a5694543510c0c9b7b5915f126460dc54c2d26b5701c8c9b90ba65de60ca"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

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
