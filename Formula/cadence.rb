class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.8.1.tar.gz"
  sha256 "98908e34588e555977821b7a8873f621f7ef2726a66756505e08576a71d5ce91"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7fe58786e0356835ecb38655cb743c7f62707c9e9b810293a5d34e5bf3a79dc" => :catalina
    sha256 "c7fe58786e0356835ecb38655cb743c7f62707c9e9b810293a5d34e5bf3a79dc" => :mojave
    sha256 "c7fe58786e0356835ecb38655cb743c7f62707c9e9b810293a5d34e5bf3a79dc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    assert_match "Hello, world!", shell_output("#{bin}/cadence hello.cdc")
  end
end
