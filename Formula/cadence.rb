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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af1cf7aefdbd259e0f39e64a0c4316719b7db47812c1b53b8613ded6872b7f11"
    sha256 cellar: :any_skip_relocation, big_sur:       "72f1d5e65626ecc8f2e6b57884c97ec016379c550b6460d488d02242a6125a23"
    sha256 cellar: :any_skip_relocation, catalina:      "94664c8bc3a57e3c2c24f1ebc6b412ac56bfb84119a3169dcb2a650c167eb5ce"
    sha256 cellar: :any_skip_relocation, mojave:        "9cca6d6f9295a3dde0721d92dc5e8a21ddb32321fbff122c22474f0a12bb5eb7"
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
