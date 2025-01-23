class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.29.1",
      revision: "ddfc3b1ea724e2580c68d34950f0ccd318ae3ebf"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb68725ef7876fe0017994c7ede07499493d6c3e9dcbd193f7ede31eac4a408f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb68725ef7876fe0017994c7ede07499493d6c3e9dcbd193f7ede31eac4a408f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb68725ef7876fe0017994c7ede07499493d6c3e9dcbd193f7ede31eac4a408f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9e9ffb7d289f71a1fe903b22aba0a333b4d48fd1cfb30f21b9399efa9c6b744"
    sha256 cellar: :any_skip_relocation, ventura:       "e9e9ffb7d289f71a1fe903b22aba0a333b4d48fd1cfb30f21b9399efa9c6b744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8700ba6326f9fd8c565fabfbd5f3b6c888f9a6fc251bdab1e6ca4523cc5573"
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
