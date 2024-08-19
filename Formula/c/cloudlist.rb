class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "b5c58f1d0c01056cebb6211fce2ce832936e8db65e4f0793d8db3026693cf6de"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55a03f124f4a5d99a3d8c2c1abaed7f20871740863078ef8062cbcc179e0fc21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45324172acf08f41d399a7540481768788ca29e7f88251171d06a85682227a3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2e1180fe3d6967739c796148ee5ba8ddd213ddbacd3181fd8763f057a458659"
    sha256 cellar: :any_skip_relocation, sonoma:         "0429774881d361012204bc2d755ef609f7f2b87e21ae8d2bc57f84f338d37b0e"
    sha256 cellar: :any_skip_relocation, ventura:        "753daa8b0dc8615c052d680c78a331adffe8122f74114240ee3ec3493689c549"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe8abe45782380933ec8dc7d88ee36f3585d17f42118420a6f6032ec5fc73d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe8ea61cf7e81ff7185383415584701feee4d0ee8249fd9809c4fb37b550522"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output bin/"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
