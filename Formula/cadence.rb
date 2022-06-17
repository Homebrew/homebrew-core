class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.4.tar.gz"
  sha256 "22b114c69468446fcc7db88a4f4d0c0457453ece516ddf14e0a99a37f9f59f71"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d34f6969b061b9f8f9281ef03cba7a6389daff9f0e7842ac60fde280e637a6bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "529a766474d4ce8e0e98030ada60d4ecf61b4f35ae8871a2efa2358ba2d9b66c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d43fea4db07c050f6672f11a94edabcab609753de6d5a745d5a152d5f02b144"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cef96b97593112cf1712d6639a6c532670b9570391cd3fdba29df8ca0a29b20"
    sha256 cellar: :any_skip_relocation, catalina:       "457d427a513ddd4d68138499405b90154cd22ae006a1a83f16ecda4ea8344386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b42aa32e5958fed5e4bc29562cb40d317aef34292272603a0684de6c2a9409"
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
