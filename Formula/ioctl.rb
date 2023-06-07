class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.10.1.tar.gz"
  sha256 "e9958f7d44e5a390f41d615c09fabed5f2ae34dcfa391d3f5cd0f53c058b55f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bc6b2f87ab56ba646012ed47f40fc4e9ca894539920539b3d48130e06e645f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c409d43830f6e690bfe55d02557bc72991f7101a4d28bed0b9aa83a78f58dc6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea0256d4508ac4868db83befd4268b604427c64377ffc63ed4e336bee834abb8"
    sha256 cellar: :any_skip_relocation, ventura:        "2fcf2db47fecf152c249cd688a6ce42795c6271d1e0d15a5ad730d95a7c08b50"
    sha256 cellar: :any_skip_relocation, monterey:       "6ba7c77202a9c8cb8e08f0cbe86ba386f118d27ee29992aaccd22a2b130c5b85"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bf911d704600741569a2b4765d91e467d7cb8551422b5eea62d804c4dc5d02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5dfc69f35745c285fa51daf8f5e50725c4be7cbef3eaccc8a0eebfd902c99e0"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
