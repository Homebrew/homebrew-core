class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.32.2",
      revision: "db255c554b929afd73552fd3ac81d691107a1607"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31f781a4824169ab003818e55f420bb2e78f17db5ce98292a3bb92a85f09e7d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28516ca98a0c5d105bf08e87103527d89293aed9860f245fa1625b37b7e64e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75d3b0f237ab9afbb9846ce96c366fdef07083193f74a7cf2d55c3ad6fbf3bbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0a29376d8f1b4009bda390b5542a647fb53139eababff658b572e5a05fdf6b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00baa44614aefe1ba6b9abb106e3d61ca1c20821c92edcbdeb016cb58ece210a"
    sha256 cellar: :any,                 x86_64_linux:      "93c7420a0ee3e63a84a2eec89d7f87f17c2cbfacf431d05fc216eadea7017087"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
