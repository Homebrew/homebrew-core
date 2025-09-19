class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.30.3",
      revision: "068c7aa62a62c7459c9ecbf929c92f2a6594f22d"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a725de2dab9c0afb29d459044baa1ab26b7bb1c33712841417b4755b9c01221e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73df886e51849a9ef8ab02c1ebd9d4ab55106e9c64892638f870923e36a3d3ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73df886e51849a9ef8ab02c1ebd9d4ab55106e9c64892638f870923e36a3d3ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73df886e51849a9ef8ab02c1ebd9d4ab55106e9c64892638f870923e36a3d3ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdbb4338279b2a5f3250b541ccfd7806a651852c36e2e2ac588a44407442059f"
    sha256 cellar: :any_skip_relocation, ventura:       "fdbb4338279b2a5f3250b541ccfd7806a651852c36e2e2ac588a44407442059f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29424437fa85d5a2382f032cc58defee797bf583512af80d50ce5ee201ed45b"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
