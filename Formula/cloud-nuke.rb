class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.9.0.tar.gz"
  sha256 "095e77943cc06a872fa4ce8e3eb2dbc5e07c3363e3221b5875a7cb2ee1ec53aa"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d766fc959998328a1099d172d9f5a2976d3a4ff5fbaa914552be115fc8bf9982"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca4f7cc3c6604094ce4e16087c3946550844fff66110306bd7bb967e71b39451"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff244bf269bcdc99c3b95c0ff72beb24284b36ccc2e6c39af674111a2fe4c20"
    sha256 cellar: :any_skip_relocation, big_sur:        "849bc4697581a65f939120989e160121daf75dbdc807a4c753cad4b2088b9c5e"
    sha256 cellar: :any_skip_relocation, catalina:       "e716690ff7052471c575ba52684de959d7bd70cad797f4027a7c9a333717992c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5495e79321db944ecaf94602be86f54186068a73ab67815c6fc5766b995555fc"
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
