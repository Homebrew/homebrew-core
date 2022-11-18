class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.24.5",
      revision: "f1a1611acb98d9187f48bbbe2227301aa69f0499"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4725582827d92ffffbd916f76562b8a1b07f9d67e37f03937679e70e921d022d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0380924a331eb4bc344536dcbf32d4b7af6478bfeb7f64254e7f55711583099b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75e03bfccede56db5d90d06b05becae38d34664adf7578a63129199be902515d"
    sha256 cellar: :any_skip_relocation, ventura:        "c2bd953a921d89bf6cc8de0e49ecc14e9c5647508b3b608ec299fb2eb291544a"
    sha256 cellar: :any_skip_relocation, monterey:       "76f96acd7e89321c63e4456e4a7335075e64001f3028dafc333a9fc4272434d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "79515710768c1466cab5ce1e5952bfbdca0306581e05faf3c1e3b4960b79d70b"
    sha256 cellar: :any_skip_relocation, catalina:       "1b0a9d40cd74f3d9193c43ba49aa2e32350c6b2e4c1593a94c48415ca613f7df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0747371a25f6fa1ca273d1b76f0db692774ec3e47ca73c4a9e60be7ad9ed1246"
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
