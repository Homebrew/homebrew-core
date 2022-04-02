class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.23.3.tar.gz"
  sha256 "95790c72cf0d75ec80e2870030e7594314df06cf7c35ff43d80ed5f17008fb40"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa607c142561e7c35a01c990d8baf11e7994b912008082abc0f740ba5e42d062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc0b838ff4af85d4c23c07f857715c886962a0b82baea9d0cad2b2f9379791ad"
    sha256 cellar: :any_skip_relocation, monterey:       "5523b8d11057f02ec05682c841c2aab00c24eb9c617337d27bc8fb0413b6fc13"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a9d78980074cecd72dffae97103d78b65928992797110e75e9960efabeebb28"
    sha256 cellar: :any_skip_relocation, catalina:       "819bb26695f25f6b2a1fc512f2a650ae2b98e753d9d518227a780c74a4be3676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5bb7bf381ebf8095fd30f54da13c4fed5e98b426de543e5549a8bd28fa2ff53"
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
