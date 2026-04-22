class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.31.5",
      revision: "2e4da40144aac869e1ed2cc220b6c4b62f32efdd"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "941d2905283b26d49a3a833af333cbb5b92f34c61b906d93cb858c4b7e333eae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "941d2905283b26d49a3a833af333cbb5b92f34c61b906d93cb858c4b7e333eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "941d2905283b26d49a3a833af333cbb5b92f34c61b906d93cb858c4b7e333eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf99fd2f62fc0bf11bcc7adc24aa84541634a0d3a8a26d5979fb017b750394b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ce28c76729c3edc5fd229d72b30c22107f49dc6178cbb24d6495a561b549b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab454cbd3610d479b69771ea701b12a5a33b545a240333df2ba811c0395fe68c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/projectcalico/calico/pkg/buildinfo.Version=#{version}
      -X github.com/projectcalico/calico/pkg/buildinfo.GitRevision=#{Utils.git_short_head}
      -X github.com/projectcalico/calico/pkg/buildinfo.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
