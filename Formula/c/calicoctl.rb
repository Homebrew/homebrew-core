class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.29.2",
      revision: "c29210835f7a2795d0791974602c8e1c625c8ca1"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ecdcc4a9e2cdba345b3dd11aab7e9bb725c1dd93c92cbacc8e1a29170271f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94ecdcc4a9e2cdba345b3dd11aab7e9bb725c1dd93c92cbacc8e1a29170271f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94ecdcc4a9e2cdba345b3dd11aab7e9bb725c1dd93c92cbacc8e1a29170271f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c395b626f5c0ca33c22f2a31df2ab53c69e8a140d7e9347afba4bbbcb0567dce"
    sha256 cellar: :any_skip_relocation, ventura:       "c395b626f5c0ca33c22f2a31df2ab53c69e8a140d7e9347afba4bbbcb0567dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9216084190d913c76764b7e862f79d42544e30b59c0f79370ddd83d65d4b556e"
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
