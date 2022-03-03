class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.23.0.tar.gz"
  sha256 "66a6a6ca7a8498179ba417331e79e68f24d63342995a2af32d514fa523a36589"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e1c805afd72c60d4e4b5a6f394a363a63bc5aa6627a3017e5c3129405b5ccbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fd0308f574fec58cd281abfa56d310fe35e0ab9a6b91d200e74533d634c3235"
    sha256 cellar: :any_skip_relocation, monterey:       "7368bca3a0a41b17afefe3a7f5c9fdce95a8ae1145520feeda2bb2bdf7d2d705"
    sha256 cellar: :any_skip_relocation, big_sur:        "85cf647cd11a59ceac3927fb34065be4c40089fb04e79ce156064a3f3638a12e"
    sha256 cellar: :any_skip_relocation, catalina:       "a6753b8421e3a35ccb64ff9d56e1739eda8fac933bc58dedcbdc1f365f782512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b267214f8d9c9b1f4e428c7cd8b58c9f060913f695db9dd1ecb3c5ac739daf"
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
