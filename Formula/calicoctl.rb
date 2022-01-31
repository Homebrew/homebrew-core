class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.22.0",
      revision: "a86e41d021c4c60e1f73d8dce396fe249d708cc7"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "260143f4b53540b5c49a58924458eb2106407a5f210e258d27eda2cae8ab5c90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3691c20bfd19bbb6b8be9c7ec0c1aeb5a61ae9ae6b0839f6be7cd3a2aedf5dd"
    sha256 cellar: :any_skip_relocation, monterey:       "113fa9202409f57b079f23cc2641259801b0f756bbe69c8e7e6b111b81497aea"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a82714f2b812e50782cc19061a87bf7a99c5894a787b9276a453bfcb9b72597"
    sha256 cellar: :any_skip_relocation, catalina:       "1636b55060a0bea0cdcb54a88b030c87bf928b04e4fa0c10507fd50fb611098a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87df8eaa6e8354394c953eced98554d1c5a51c2a08581861219057ce1bf37c3e"
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
