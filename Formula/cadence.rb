class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.23.3.tar.gz"
  sha256 "95790c72cf0d75ec80e2870030e7594314df06cf7c35ff43d80ed5f17008fb40"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "724260642a67fd710f11b28ba37cc8f700f684b6d24314e41428e3caf4664679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd8dd2135ec681e162f7767d2bd03831160f0484d4a96ad0c737ebc8c281cc21"
    sha256 cellar: :any_skip_relocation, monterey:       "49e5cbb0690ab060516d59afaa796a3a40a8516772fe1d059e621d415fba8811"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e18c80bae981598bd1d79bc2c4fce35b7556dd78639a3715a906bedadf2df85"
    sha256 cellar: :any_skip_relocation, catalina:       "02587c5b11f0e8a1755624458ae8228825e86cb64b6e62ed552f5552e6b1d7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b43a079fe8161219017f6b72171be9160cfdb9d37bdc16de7dee0724c69192"
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
