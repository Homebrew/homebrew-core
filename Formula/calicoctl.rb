class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.24.1",
      revision: "83493da010b27b2dbc2874c80a092a4e3ec7ec34"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54e1e18d62b8a0811dd1be8e697d0a3d3a9989ac150c1b46588288e53097e8f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23d90146c4980c398f2c753200e80ed7eeb4589d7f6d567db04c9b9de1938469"
    sha256 cellar: :any_skip_relocation, monterey:       "35c7a950840f77d6bf87029069be5c1854792945ea600c52d28de188e0e39d21"
    sha256 cellar: :any_skip_relocation, big_sur:        "134a1b45ea50ee2bfb2c8550f2a734f5a5e30e9381eb34b37420b18863b477fe"
    sha256 cellar: :any_skip_relocation, catalina:       "78b7a91e022e28cc19406f3cc471d1ba02faadfa949cb104845d0e221f0c4b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e6a466f1719f447c9ec20107b649363ce796dfd6669b62ea2f32e9ce44c4b6"
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
