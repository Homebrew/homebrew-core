class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.1.tar.gz"
  sha256 "7bdd1993e65f81c8e2a8ea20b186b32b895fe433b3324b65c94d5936d01c3f23"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d1698521d6c9b52d99a7c851983b935c569112e85b63f48683a43804ba50f98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00bd4cb362a29da81e02e57d5df3a6c049ff567d2dfdbb7e7c033e930f8a783b"
    sha256 cellar: :any_skip_relocation, monterey:       "3248a805e1a2b8f76884c1e9c76a95cd05b2a0eb317870a475ed6d03788a76c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ef35a02c6ba22412e4a77fcff635a301f2786de86a1475204a7da8c9c446a85"
    sha256 cellar: :any_skip_relocation, catalina:       "670a3f05c24b5281d5dffe488c67ed4c37d2486e6cdd84dd104577e007ba56b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "895a60a61593bc25a1aa93d469113b7d85b6bc5ffb7e54b91a1ccbe18a9446b7"
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
