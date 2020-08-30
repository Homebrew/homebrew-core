class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.8.2.tar.gz"
  sha256 "8691ad36cfa672e7f45f61b44159b949d5eae252d70a921190fc0aee48349587"
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
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
