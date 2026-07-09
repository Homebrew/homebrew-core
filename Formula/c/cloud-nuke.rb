class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "7a5d6f0feb99ef76943992d5a21d0f9c922e754f8da747c0df479d734a3bb4b6"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b48e612d87f7ad79275a60af60f0cd93a8e5fcec128d425d9360bceabe2f6922"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b48e612d87f7ad79275a60af60f0cd93a8e5fcec128d425d9360bceabe2f6922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b48e612d87f7ad79275a60af60f0cd93a8e5fcec128d425d9360bceabe2f6922"
    sha256 cellar: :any_skip_relocation, sonoma:        "ead8ac182d15ba793c4dcc5ca271c07813b609102c167a6e613ed6251b9bf0f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "432f60b3899c68409fb550f97935fd992f4f59de34a57f6a9dd30427105bcbb5"
    sha256 cellar: :any,                 x86_64_linux:  "5bf4a253f2e4aaa00a667a536e0f620a76aeadcbc172781312fada015fa16b1e"
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
