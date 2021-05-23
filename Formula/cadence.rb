class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.16.1.tar.gz"
  sha256 "1e54e4eef29c3c445bbf245701e78a5c88493f5d5ede3389b81018c75dea4c89"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a725a8582a6267399adf25bee06e0e05c807786a55d5b5e29a00976195a60551"
    sha256 cellar: :any_skip_relocation, big_sur:       "81ce08d72b52dbb031ebf78a316994f2180ea3e1bb968a76b7faa2976f988f04"
    sha256 cellar: :any_skip_relocation, catalina:      "a85e73743c702296a92352b52fcfd7f188a262920b5602ae680b7a16d267cff1"
    sha256 cellar: :any_skip_relocation, mojave:        "6d77422639bf2c6873832991f1a814daae02502a648b4bb439607e1e922a027d"
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
