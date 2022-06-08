class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.0.tar.gz"
  sha256 "aeddc6ffbb45aa85ce76a0aa7b0a7eb68cedf7f7ba92dc8ca2f9ae8c48649ba4"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "952686756ca2cd75bcccfb65a2fd3756bf8b7d0a06e8e3393e22aec7d7ccbf60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a078374f33460ca9a5006364b2c4d9a501353581529b3da37f3aa4af5624052"
    sha256 cellar: :any_skip_relocation, monterey:       "dae6013f20013950cc6bd7310e8d2c072de53699ce157a299ade1aa86c06c89c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb7074c8b3125d7bada24a04469eeb8c37bd208067c020073278f188780359b7"
    sha256 cellar: :any_skip_relocation, catalina:       "58e123d7f148e81dba6320183fb8d2b3fbe75b6e486f8b448959419025b69e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2e333912db1b9306f529a812c00b05d9937408c2190d30cec505a8f17e9279"
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
