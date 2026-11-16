class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.33.1",
      revision: "d95e175f6be5a0e8ed29645ac8faedf08bd800e7"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dae74e5d24aba98f81494e2f0ce5e2eed4b159cadf9ed1eec5fbef2b8eecd710"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "828c2c8eb75b2f8d4c55bb086fd3bf652638809ee8980890f3e9a7ee7706e6f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5012054bb266394da12bf7525b3606c4cd50bb3b993dc0cca14ffec9266e8a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5685f47945ddedd0349c6a6ca1336db4fff5d4fbf18e7b7e22077542f76a42c"
    sha256 cellar: :any,                 x86_64_linux:      "4f3e6204efedc15402014e5c747cbaf71e6195c5098b489473d33a0edcc7cde0"
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
    generate_completions_from_executable(bin/"calicoctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
