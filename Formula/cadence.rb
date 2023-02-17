class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.34.0.tar.gz"
  sha256 "27bfdf5fbb1ba4735c57204294cf5b7bf0a8d721b7014c65e66a99b1eda5a910"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ca6221899aef634baa91a63ee92b387c1ebc1e438f78d62d9257e1ae6bb7f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e8f04bf4fa3a2cb8d6bcc1595d69dfad5d4111f2386058cd744541f335310b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f13849a687d907dc6857dccefec4f6dda9af62a70b1b4d134634de1d709861d2"
    sha256 cellar: :any_skip_relocation, ventura:        "143131e70a36928ebb1f4fd4d8fd012e1b7e7fbe8493d81f60d4dd49b3fb75c2"
    sha256 cellar: :any_skip_relocation, monterey:       "71c8bd505e22fae29a50cddd228201dff5c055630d90a373c92e9115081984e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8729e5815f35f6479e542f8f1e0d6789adb252f399098b09ccc71309d3a07d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39725e924a8faf3668e46972b4759a129c4a00722d5753742a8b700ea93acb7c"
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
