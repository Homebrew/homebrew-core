class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.26.3",
      revision: "bdb7878af3d67c690ef83ea3d008ef0498568f43"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cc55b1f3b5c3fa63e12dc12d9d3493027c3f40355e907155e045e158f7086b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "527a15d0462064831a2e88afb0253b25c8db9423fdec90a1d6efaf91ea0fd54b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f0bbdd180ba31a08051ee4b06fd62ff19f6752b8fe6bbf68c93e1bcf4e2485"
    sha256 cellar: :any_skip_relocation, sonoma:         "14f1c5a05ec7e8a3d977fbf6153012e3dd04de7704410c193143e35652f0b9d0"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff8e0a6a81894ca65a42b055de343391856b00db180a237cd967aa55b5777e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c6d9c8e6275d56d31645bd9b625c5713883fa55e41ba5341b89c6fe9b270ec41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "032e81574a4a0dd61d04d1765fee7a7684e7f4f9afc995a1017a78bb3d124d85"
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
