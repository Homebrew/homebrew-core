class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.5.tar.gz"
  sha256 "fbf0a5db17407fac1f7f85ecdb69b695de9627004ca93a228b3399eb6433649b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af201e318d5859e87ddc97d1720e338d30b8b153513dd65fb08739fd546fd7c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d5f4d49ba8c26935670f43574a3900e1a5ffa2620478316f54f25fd553bb0ea"
    sha256 cellar: :any_skip_relocation, catalina:      "05a883e0bcfd6cd1b19e7a5d8d99ecff207083b576ca670cd6e2fe5e900df68a"
    sha256 cellar: :any_skip_relocation, mojave:        "0302bf98720ddadd261fe120dfe79d6b92941d63bdb5cd1b1627b1509ee4bef5"
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
