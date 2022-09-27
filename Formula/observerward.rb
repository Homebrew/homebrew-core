class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.9.27.tar.gz"
  sha256 "9791c1f0544bca6414e6979e50d985b748eb3993bac8ddd6f2f0b86f2173e086"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4272829099dcc66db68a20fc870b2816ed21fbc0e6b5dd8277d26a4521bbef8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e1843d99a0bdd930f3e10ff22411d4cf6a516f6273f010e6b684cce16eaa9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "50ed208a0f1aef6974d6837620a512a8c3ffab36212f80465eda7d361956f094"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a34893e28214894569f6002e3bb4305b34028c5158914b5eb623957d146774a"
    sha256 cellar: :any_skip_relocation, catalina:       "64e9969f27b16bcb3e2ca4ccfda521d99d9060232d646921b896cf7511ac7c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80fde34e02eb437df7ba5ff90118f31ea9676eee4764f40ee007c4a25ffa6685"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
