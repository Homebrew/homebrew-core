class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.30.0.tar.gz"
  sha256 "a37df518982c9cca2ca5af4515f3fa5953e0314cd9b5e8e6cd786196b5fd8d32"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf0ab51b34c3d6b4eb1181bd256ef8685ef20493a32b97e070c37cf002a5a576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c4ee2dac5e977d4314382d02303df862ecea09dc2edab5c3cb7f01fd627c281"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3380eabcaa43ad1cdafd3d6b20ec6ca08756d710b30e9560cd701249d7c5b5e"
    sha256 cellar: :any_skip_relocation, ventura:        "6d08e270d85f0092d56ff1b0a7c25f22e26193467a6ceb3e55485bbcdc4435df"
    sha256 cellar: :any_skip_relocation, monterey:       "293a46b709e0ab058d7d08ec9c3b3170a2583c20db426265c73e519c471885c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2314336ca99b7829c075e21f902c6d8df64648598b4c90b3a02940a39e5c5525"
    sha256 cellar: :any_skip_relocation, catalina:       "0123b80446b7a3148b30adc21beb0ccd071b9cc4f58f237b9167356e4d3062d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ab60debdf4a1193e3205f5b927e1a6b5d76dcb45aa7508bc67884ad5791e868"
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
