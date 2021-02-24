class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.0.tar.gz"
  sha256 "c2193ef4682129a26e9f78cb6dc70ff8bf118ded77939e975d5192ba7b501a53"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2f66969f29bc9ec55d5cebec7bf64b3f1b5e02639c65e9f28c9da42ea8075e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "3004ed108e908bb5f72410f0caebb273f5784b4bf87a996ca78c9edb01127ec7"
    sha256 cellar: :any_skip_relocation, catalina:      "4127dfcba0274b48b8cbc3732dc7ae57d729a40fc051bccd473e33a7dc4876cd"
    sha256 cellar: :any_skip_relocation, mojave:        "0ecb0d55d3f1187be656c7399da41cbc8520f5f07a32c10c6f3245ae2cb5763d"
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
