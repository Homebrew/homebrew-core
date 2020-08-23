class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.6.0.tar.gz"
  sha256 "2e18cb91308794065a0242ca4c15d7584da9e6a08f78072c970f51db3a470412"
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
