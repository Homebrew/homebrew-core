class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2655c117bbae083519e5886f39d944e560e8796a52fec3e05789fd0dc5ba5c53"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88ae6e657560e01aa56db7efa4f43b64019a69d768a8ee40cacdf9230a57fa7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88ae6e657560e01aa56db7efa4f43b64019a69d768a8ee40cacdf9230a57fa7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88ae6e657560e01aa56db7efa4f43b64019a69d768a8ee40cacdf9230a57fa7f"
    sha256 cellar: :any_skip_relocation, ventura:        "684c9ae8317c75244540d7fe6ac85c639df0d9d23ca20aa44b6d640a5f418d40"
    sha256 cellar: :any_skip_relocation, monterey:       "684c9ae8317c75244540d7fe6ac85c639df0d9d23ca20aa44b6d640a5f418d40"
    sha256 cellar: :any_skip_relocation, big_sur:        "684c9ae8317c75244540d7fe6ac85c639df0d9d23ca20aa44b6d640a5f418d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be423e2d28da83d86d5901481ee3850f4c74895370890d08687b0cc10af04b8"
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
