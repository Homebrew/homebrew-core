class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.6.tar.gz"
  sha256 "9b67bbc69b9f1089203dfa96a0118e06268b6d56a2b8a7572676e0257f0183fe"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4db8c7171e3e3874197e1a817e3ebd3fa854c80fcbe6876acb45d87399bab65d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e1645e1bee67eeaf664a21dbbf6f0de702e6f38736fffc44b5e1ae606383eda6"
    sha256 cellar: :any_skip_relocation, catalina:      "d6ba374e4984fa820c59e22e5dfce4c6d8db53a1ec83be9e1245eeb71187d708"
    sha256 cellar: :any_skip_relocation, mojave:        "d8937fafeb3767dd4c5666e4c063c0020dd0039003dc20a45e3a698b674108bc"
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
