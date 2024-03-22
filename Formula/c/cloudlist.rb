class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "d2ab36f0d8c7186778f30da8d69b828c3110ae1f91d6a6fc72db911e8c2f41df"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62f3bbf69fe4091f59d50e6879dfb4689c831d59f1dd53f5b0cf7003bae442d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87b04aa8f61c1ffb206b9481a1d9c4156f6fe83ae7f746d9a0456e86df2c65a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24a85205b787ba0f038f0fd018678fba7e4530c37ca3fd3254bb96a9b8c03ae9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d81e38c4048e5fc2c170c31f8ed09e3d133b15a259f399e8ae72f09299f7075d"
    sha256 cellar: :any_skip_relocation, ventura:        "fb64a9e27346d803ae9e828436b0130df753053a71947b87c2b1141a93abd660"
    sha256 cellar: :any_skip_relocation, monterey:       "c4bcc04c76658ab22998d62f9167649f1f789bfce343ad081be167cda24d9b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db4c147ea9dddd11bfe771f6e189c4a496c3639947399fcc8a492a88c8f85eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output "#{bin}/cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
