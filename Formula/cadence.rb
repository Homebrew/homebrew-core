class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.7.tar.gz"
  sha256 "1b5774b0ce2806176f338efc7eb886e338b87d705cbd66978c2535e78faf548d"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a6ad7b27304145b5029b5473621e073ccf962d388fd4a2685219026a6f9f385"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3dbda524a438ff5db8bf40c585c05d8ff29a43df6c36e696cc01b2e966ce9c8"
    sha256 cellar: :any_skip_relocation, catalina:      "0cd3c4071b3e287cd03226d66da03f93e020800ce07f125c14257108c75226dc"
    sha256 cellar: :any_skip_relocation, mojave:        "cb034c8a34c2d63bf699e906fb82d0d5dae4314723d3d99444200a8a32f9fb5f"
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
