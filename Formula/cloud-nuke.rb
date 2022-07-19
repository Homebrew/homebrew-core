class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.15.0.tar.gz"
  sha256 "ef3ed68df5f92b4d5287ae835504da53dd8ac13a63156a21234c2a7535887549"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1973a8a538c13dfa7cbcd63d15335f665b5cc281104b72f3bab0e0c3f66fff51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4432d4ce061361eeb6ccc296254df2605ef8800fccebee5935f6aa67a571c8f"
    sha256 cellar: :any_skip_relocation, monterey:       "ef03859d1852b8072a800666a62ea830a796975b2706a8f018adbd3584242da3"
    sha256 cellar: :any_skip_relocation, big_sur:        "00bf6050d43a93d993c83800bc10e333fee1bcfcb90aa3fb2eb89e8d52902127"
    sha256 cellar: :any_skip_relocation, catalina:       "f06c23d7773c6008de8796272fc12dda282ae60a483d94a1edb55b5dcd36a167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbeff16ab1e2c5e9fd6aa38313156e8e093e774880276483370c4386f5a24214"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
