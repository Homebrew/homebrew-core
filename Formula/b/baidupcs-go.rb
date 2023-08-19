class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.9.2.tar.gz"
  sha256 "da7749bb0534f23154cbca7aad7e77d5531c3aabe458a0a0b1cd618b76f59217"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a6296c9f0196a0525732244a03f983c197cc340c5658d259f05624a91d7d27a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a6296c9f0196a0525732244a03f983c197cc340c5658d259f05624a91d7d27a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a6296c9f0196a0525732244a03f983c197cc340c5658d259f05624a91d7d27a"
    sha256 cellar: :any_skip_relocation, ventura:        "67905fed7172ac28532c8ae6a2a64528625618be7ecfe59cebad34ea95a28080"
    sha256 cellar: :any_skip_relocation, monterey:       "67905fed7172ac28532c8ae6a2a64528625618be7ecfe59cebad34ea95a28080"
    sha256 cellar: :any_skip_relocation, big_sur:        "67905fed7172ac28532c8ae6a2a64528625618be7ecfe59cebad34ea95a28080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a7d5cde8e8718d32b2ca2c4b433700d25b23f67a7d48ac9be753663b967b5b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
