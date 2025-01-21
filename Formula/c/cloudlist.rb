class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "63f288b08ec4c1bd0969111b54fc3bb09a1423eaa0e60a9c9183e088742cd0bd"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5e5f2262604a56516bbf29acd9a60cf926eb956c4c3874569d051265f9279d09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faad163c13c4c1c6c4735c4ba6416e40afd090cc5d37f7c4182985730243e601"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1df534116d2a7f31eb6376b7bb6b5d54f2aae4b48a07635cd1906e95619c873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfbd68af5b5e83e65f674315d3d16c9107927c44bda26e756564e89522f65f5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bac836cba3909d086d61494d0449036bc7a5ef66fec2464430e64713428a770e"
    sha256 cellar: :any_skip_relocation, ventura:        "e05ef7ca27fb2dd7b8675884355ac56b508c19b26484f43275a331fceae889ae"
    sha256 cellar: :any_skip_relocation, monterey:       "477994afb4b05abcaf618a83c873677282e63d91f8b0297501c8fe66a38a887e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a9241a072e559afb179fe4726894f47d4cc20bb623eb1bf74a3fe10b9780ae4"
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
