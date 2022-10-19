class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.24.2",
      revision: "926c791c269e9a05b65777f60a6c5238999ef7b6"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "589ca0ff448e9efd4c85bef8955e305b6d6eac812f7b64c9c64e6a3f9054ad7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3c82724cf335b8509bfeab34005b3afb2c56a61ccf161244eaccd7672456024"
    sha256 cellar: :any_skip_relocation, monterey:       "b5a84a9f0fd7966610976a05734050b5e46e0eadeab31cc1a90403adf53e59fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e11dc1dfd3e0e9e0ce4a55568165d3836b81b33d465b73381300afad5e0cdad"
    sha256 cellar: :any_skip_relocation, catalina:       "b8b0f0ffa76a6007c095a0d1a623720a4d45e1ee8077864cd120109e431a3c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ec2dffa3c7ef4d64872c5e367775646d8a9e1762bf8f7cfc69aa67d8db9199"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
