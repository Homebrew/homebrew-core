class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.21.2.tar.gz"
  sha256 "91a9e031cc8596a9f2312aab04e0af0f938193ea2305eac8577ced15e5aef677"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b5568dd5c7d27f5584131db77bb980654b88ec8e47b365f5be42deb2e71489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf0942ab12bbb555293bbd9c41f7e90b584cc4c83050a16b46b44b78a4918de"
    sha256 cellar: :any_skip_relocation, monterey:       "f7221fcc236e77fe982692d4007ea37f63ea0a9c68d238864790d913a4d2d77a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6ac59ae4a59f8fc09b579b5db67d8b6d58bd70a005f03b2cf6b5d400bd1d98d"
    sha256 cellar: :any_skip_relocation, catalina:       "7dd0c4889228665eda507ac809224bcb2375b9fcb39eeff900db6b1a164c5bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f73c0a20febb999f64876ca044a94cf965b805ffcf27178801a61891b832494"
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
