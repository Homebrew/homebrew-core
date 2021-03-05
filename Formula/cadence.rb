class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.5.tar.gz"
  sha256 "7535a866381e83b35f5ad8ebc19ca304a393ddd1739f13c4df7dc2575a5a8e7f"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a5715fbd837bfd5ef4997a6733f49cb56f797aff98d5cbd16cf1c0e40ef9423"
    sha256 cellar: :any_skip_relocation, big_sur:       "5de08c2857a6cd7ff4610b976941d87c5be379bace9b73b36c7a7c2a3286bd15"
    sha256 cellar: :any_skip_relocation, catalina:      "b40b2a9a285cb8436da63be3d574e48ebd13902df0f40efb62af31475e282af7"
    sha256 cellar: :any_skip_relocation, mojave:        "7845fedac0475f0cc850e22bcc7fe573967c0b858f8a83ef8be8773e871c096f"
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
