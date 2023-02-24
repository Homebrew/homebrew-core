class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.35.0.tar.gz"
  sha256 "4af6f82161119cd644953866aba9094d7949d2bb013822972fadbd0bdba4de95"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13a5f7de4f625d1443200a59f49f51d04d49ff73ea40f7fd01ac45ef7623372d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "217d94516eac97476d19861bb7a2349ffce44299424271aaaa9631b66878921a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e04b6a763c20562835978ba39ad3ed4d7ef6289639d887719636de134064280c"
    sha256 cellar: :any_skip_relocation, ventura:        "80712033710dd63462f1af3377df19819aa6defbb97447555dac49c1bc325486"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d10217e4be4085a8f1d1aafdc34a75d0170d69e2cc94a45ffa622a97a7ea04"
    sha256 cellar: :any_skip_relocation, big_sur:        "276bbd119d1228d6a45897890d2c48e7b05e632c77273d4b506474b0144fb998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c0b5d505114e03a63181725e674634d10c3f582e5d241291db80b480567a98"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
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
