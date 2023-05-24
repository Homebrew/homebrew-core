class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.5.24.tar.gz"
  sha256 "e15b99299cca237fb2ed0f0d0b7a92c21e357cf295bd962684d64d5219c8378f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9a115e1d22cd12fc0039ad0ef9ebae57bb3b62829702429728e116461886a43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55efbed2a9dfabb597e55a5bc3b5134e0221b814b1264e69d885aeba25c84040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4477ceb5c1dc175d4071563d3a0e4818d86fcb50e5936623294eaad44c734232"
    sha256 cellar: :any_skip_relocation, ventura:        "7552075502744602cebeaae91bb98a42058310d26848e4d7a645b0030aafb718"
    sha256 cellar: :any_skip_relocation, monterey:       "98ece515083dfe4834a4927d7bab1360acac4d2b0f20e2fd2eadd10718bd1d37"
    sha256 cellar: :any_skip_relocation, big_sur:        "579e0e72cd0585d68809dc8867f39d2525c9b5d9560c9efe06cfc134a488df7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e87f205a78286a88ed5a6f65abbf9445c1c91f0aaaa57c36969ca5b99ff5aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
