class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.27.1.tar.gz"
  sha256 "6f48831e1226be0a8a730bf979ea11837ff623f4a1243d5cff74e9c0fa9a5880"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfaf0211a4397f7e92c860ab99987a53bb12a92ab497c5c7e90b604d30c66e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61718f98e6915ee91bbf3cbcc23ae775df0777227efdb15057fc72a7d29777e7"
    sha256 cellar: :any_skip_relocation, monterey:       "74d1e49f96aae3a7371a66153f82e1eef25584653df97f5ae34e43c0d0a4bfc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "386afb61f2586d22ca6e16708558316d614eef097d3ff8dc3a61141c111a547c"
    sha256 cellar: :any_skip_relocation, catalina:       "9bdbfd68a81107ee1e0c09fe147dd0e3cfd697bbc6c624be5bea5cf927e33d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1fd683e7c173c34b08aad8e515989542ae3500c3cb2ad8edf493ffaa27dd04"
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
