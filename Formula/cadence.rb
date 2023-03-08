class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.36.0.tar.gz"
  sha256 "6f14e98eade0c9bed77ca79bb00b2706fea1ccf83a06a1fbd739d98f96af038f"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cf754060a2dca7d668c298916fab510c9de3156dc54202e3ca8c68ec382693a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faecf9f888433f3e561a7690fc45eacee9e772a5904031445d262458d15a2905"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f82c2ff34bac04483e4756e7e0e1517ba9a320f61b8579287f048e2d5e12dd4a"
    sha256 cellar: :any_skip_relocation, ventura:        "1d8d9e576f4506aedec3807a3ff1f784a57446b6c4f370c09512732683fe8e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "97dc723b2d9f2e83ed40bf043a96101a7478d249756aa1077d5f9b99aa6b001e"
    sha256 cellar: :any_skip_relocation, big_sur:        "14c5283bc5862554bf54fd6df9053783840dae3d6e1a7efb9dd9d987aac8d28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4472267ccbd5e9797bf4b78717397db949e13ad873a303328d9a923430a487ad"
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
