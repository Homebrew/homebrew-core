class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "9fde99ed9877efc80e6940f9958468531b72a232d98c433cfe7022fd4c6018d8"
  license "MIT"
  head "https://github.com/caarlos0/fork-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7be6259b73a094b5abfcec3a82cc813f695e74b8b2f142e806b00a81793d4ee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be8dcf5b7a339c075e68b9730dff3d8eb91995ff18000c36b4aa21eaffbc867e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a15f105d49963ddf6f1c648e37f0d015e75bde483f7729d1eae768ad6d5270d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a9469fe5d9855363b5a51345eed251f246eea5f7c21309b79ba7346e96184d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "addc6d379d35bc6162d2305581f599e5c5873280673982718066dbd39f10c26e"
    sha256 cellar: :any_skip_relocation, sonoma:         "af32472674fdc61c16a52ebaa7c3aebffa22062f76b6df03ffc69e5976f0a218"
    sha256 cellar: :any_skip_relocation, ventura:        "6c13b60356d327f0a2b7823d8bb5ff6804b2aa296f091b2e58facf6419c79cce"
    sha256 cellar: :any_skip_relocation, monterey:       "bf6404b0b8f1513ce504b092829d9985736272dd37d3a54e6975cd3a0b35ef91"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "891976e2198cc6da85de62ae26501834af4b4f049a5b78c89df29af28d9523e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e71b23dc1fe3b05714a8f2a02f3bafada4713ebabb244bfe8677de487e5a21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fork-cleaner"
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
