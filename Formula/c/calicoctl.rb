class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.30.3",
      revision: "3302e8bfd48e6375013d1d79ccb2c693306400a9"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4774a257e8583e582b178a779eb3fe9b6084bd5b4ead647f69d8a4f120a00420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4774a257e8583e582b178a779eb3fe9b6084bd5b4ead647f69d8a4f120a00420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4774a257e8583e582b178a779eb3fe9b6084bd5b4ead647f69d8a4f120a00420"
    sha256 cellar: :any_skip_relocation, sonoma:        "01e1e40b59008bbe430bc15c6605b0884cb7a43890d4ac05924fdcbbe881b349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4197a28caa1738e756c50803388d0c8f055121b2771c8f8b59bad6ae06e3cdfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "506921cfdcba075e2b1a78a483d152546e28e488b5539a2d7446758aa9f168d2"
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
