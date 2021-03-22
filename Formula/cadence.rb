class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.3.tar.gz"
  sha256 "166b4d32fa5416519fc17e16a502c01a0e7fecdf9704974db101429cfec8699b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4a3d797aa1d52c780935242f56676155430653d72857c32bdfbe37a5acd856a"
    sha256 cellar: :any_skip_relocation, big_sur:       "564f343f52eea27e0099b1f4feac2da76520a3a5f8f63672f9e2c57b08b81d18"
    sha256 cellar: :any_skip_relocation, catalina:      "aee3cbfe18e9da4d1107b62aba0983c760983eeb71486c679784ab501e418e9d"
    sha256 cellar: :any_skip_relocation, mojave:        "3409346ed7886c29f3b4b92dd8749ed0e6e8bdab5a52f3de3b2734bc9df9519b"
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
