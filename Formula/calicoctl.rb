class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.24.4",
      revision: "8032c5bc4581e712da4ae7866331e5b4707bad07"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe54578b8a4794df49e8ba9b289b14d30b2f877e9a6cb7964d62a61f72da6602"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b257a0cc02e7469f28c5675524d2641fda8c35055a280218e1e59891b3ba378e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5249b39c558b9930f16ba71c2fd56c097413a9d0cca91330181512256c7e7fd"
    sha256 cellar: :any_skip_relocation, monterey:       "1045ad0e7c3d4c93dbac6c71bb97c6235a2a70a694a371f97f49fb28529f7887"
    sha256 cellar: :any_skip_relocation, big_sur:        "be9d1ec9ff7ab90a48e9841bd190d7d2ae188194fe6219bfd80d16a1d3d2043f"
    sha256 cellar: :any_skip_relocation, catalina:       "7135ccff6160d4f1a59f10c1e39c1cbc814b276f74feda3d2076e9340d7b882f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d1deea1e857eb981fec1081635a1acf91c858fb606a82eb83195eadc04dca94"
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
