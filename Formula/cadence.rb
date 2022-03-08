class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.23.1.tar.gz"
  sha256 "b2894930dd6c766423524739036fae2665b6559aed56fec91cb2895b840dea69"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "344affc79f96c20684bbae3924c900d43de9f20215c7f2a9fff586cfa54fbe8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e99857cb60092849b6dffc9213e3e02c21aeb5efd54566c4e418a13342053033"
    sha256 cellar: :any_skip_relocation, monterey:       "78e74f9b06b03f2b7357a0842c83982c484ca2889c3b4a159bd2010ff16f45d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f0a282a9d8497aeb520e2ba58d262ea4b40304c07cfd5230a56e5ad6b95fcf5"
    sha256 cellar: :any_skip_relocation, catalina:       "2e094cd313c1fb79d9eedec36095722a5840c515e7d7d22063a8332ee4f3c116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c70888b23177e8c01f34c9c0353cc282c50f9fdf80c054c28b55b5953a9efd7e"
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
