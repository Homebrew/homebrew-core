class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.19.0.tar.gz"
  sha256 "f0bddf4b84d112e251b1464ed8ff0e1d83130c1c52f0d27ed7845c82cb399661"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bea6ad35403f4f41e324b2d73a0fb971b66a86d23af11e1ebec32cba62a869e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6457cf6f05ecb29587b83b3bc14989c51dd3f948720712105f82cee61cf4d13e"
    sha256 cellar: :any_skip_relocation, catalina:      "b295e535e254cc5f6ebcf409f156d2b08f76a75e10e1c17b69bd0a13139b4f93"
    sha256 cellar: :any_skip_relocation, mojave:        "bd58b4576f408d3971ec65e7754e429ba06c070ee9399b009b798a63b6759511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e24c37da522252f3160c56ef94403f4f106d9ec36249a9a87da8a00c3bef6d"
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
