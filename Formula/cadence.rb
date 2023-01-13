class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.31.3.tar.gz"
  sha256 "8cbf6457675ca7eca4fa1faf60dbaee800179d248d9b66eb06c1e3e21e692e28"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77dc98ab879525f77785553330422ad0abb0638d20d11ddeeb6bf029bc79d2ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5a045e69c5c22d223896281f2388486407c09e5f1e30ea548e43fd5a1dc4eb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12feb8cf38857bc3a209960542fcafa6962176bbf5e3f19586c5b65eecad42a8"
    sha256 cellar: :any_skip_relocation, ventura:        "3678941bcbc9127cbe694e7ce7c9796623acb73250d5409a6b35bf8b76b06916"
    sha256 cellar: :any_skip_relocation, monterey:       "6acd785ef09c36e5ff5f8aa824b741d60a31e5460084448f593e9d877fa0733d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7aedd016b19397c7828416abdbfa7fdf00af890a5b492e8ae07d990b37b4194f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a31ff6430f6731c328934c342eecafa916b138ed1390a19114dfe87744acb007"
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
