class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.21.1.tar.gz"
  sha256 "786c0c3f1f2fc96410e412d5b508170bc1d0cf4738e630f4cc1d78fb61906c05"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6475b376f966ab43af7ea0ee89124b41bafdcc4c0d4a25a7b483623d063a2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a74ef76f1a059420384bd2cde8baa4ae4d2636592654e1759019b2afdc64618d"
    sha256 cellar: :any_skip_relocation, monterey:       "910c10c713033c8884543afd6b1fa2f3d9bfb852e6793e3df14f64b5f699c009"
    sha256 cellar: :any_skip_relocation, big_sur:        "a363c8ae4866152de76b7ed064eb3bffc4f1eec0e74f54b093829ba451ecf5c4"
    sha256 cellar: :any_skip_relocation, catalina:       "ede066f71f3ff579ab7b1553f927f7fca89dd593e18ae55d4cc75a6af759d863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95bf51f2a59f24e620eb7751e613c0cfc417aa03c4205940db79fae374576a7b"
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
