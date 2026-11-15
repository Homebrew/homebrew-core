class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.33.0",
      revision: "fbaa371111636a37ecc82625fce8453064a7fff2"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b746a75c8443df6388bed893cac7003b4922efa3fa2a0784f7cd126d16b7042c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6011a710e926a10fcdb2b6c5e9f066bc4a7cfc285ce946cb10d0dc253b122ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ee71d0729442103cb102b49869f4fa45669354da8be3d1d941d2358386fbf87"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "484c318c339fa84a8feb33807de51de38145f12c271bcc9b62028efa17e6cd46"
    sha256 cellar: :any,                 x86_64_linux:      "081821fcf268ea32c2a6a861b4d3803f52c4c7e92c2170cca8e4df76193f7bc5"
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
