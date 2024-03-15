class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "63af643176a1de60c0c7a90d8f02f1e07e6611066a0079f8152f1a2972fbc203"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "995ecb6318e5b2b2d3ab695996e0975d2d3f0bf74a4f43f5196b6f14c3f23356"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83a509218c15da1b29b7bcb508b626261ef2d37d59e50b7147d1b5512bc4266a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df9e01779ac1f519dc792bcfe6449698491ab76e3fea0eeded89c233eb94318e"
    sha256 cellar: :any_skip_relocation, sonoma:         "03047a5b5317a8c3e60d685b967bce6fb031e740f7f2b5e06b95106f4b959705"
    sha256 cellar: :any_skip_relocation, ventura:        "e67e651d5989201c2b979df34e41c4a929d33028ba735332962fbbfba493f67a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f02c5a8147e4453540f56ece60242eb5cb447921fcdc42db962236091286528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d194cb3a4b25872e354dd9b304349eb671cb88c135ecee445d6d0bcaeddd86"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
