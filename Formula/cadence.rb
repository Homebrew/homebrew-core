class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.4.tar.gz"
  sha256 "5b93186476144bb35680676f60a6d16a1b4cd79eec1d40a11151004774a517bd"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3795f124d27f498bf1307a0796f2ca1ac7df855be04127725d8837d4c8da52b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8f38ba5d8f702d583fe47dcc112cf814125a43c0f7e3840a4e019e91d3eb95e"
    sha256 cellar: :any_skip_relocation, catalina:      "4cedb2dbdb03e962e9b687fdb5bdcae13723755c125b84fb41e37500468510e7"
    sha256 cellar: :any_skip_relocation, mojave:        "da80d1e83cba3293039fd768c3667b614673dae7728cfbf3dc2b646c5ea0790c"
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
