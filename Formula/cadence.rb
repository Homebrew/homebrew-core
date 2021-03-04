class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.4.tar.gz"
  sha256 "3f349e1075d68cd1e1e7ac9ba0a1c1ffe29e82f624230eb55415b955390c3759"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "099f2f923987d23148009cd5bec4e97cdb908e8abb8eab8d56088c7f92d37f58"
    sha256 cellar: :any_skip_relocation, big_sur:       "f814311efebcd3abee150903dd8a318f49e69f5f79c4ffb3fac55e9d67b7f314"
    sha256 cellar: :any_skip_relocation, catalina:      "94a09aab90ca3e902cd0c1a4978fb0d35d633270cbd934ab2a32f63178b4c61d"
    sha256 cellar: :any_skip_relocation, mojave:        "f9e579391570e42a9ab3034e93d9d0f6589a8726b1483131172b2120c4b5f7e0"
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
