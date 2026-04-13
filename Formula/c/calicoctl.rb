class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.31.4",
      revision: "6d8c39b0ef01cdf92960e08f704c7198ffe42eac"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f687ec8c275038dab2e31e96db36e528684608f8505341b40df2dcbf951b3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f687ec8c275038dab2e31e96db36e528684608f8505341b40df2dcbf951b3a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f687ec8c275038dab2e31e96db36e528684608f8505341b40df2dcbf951b3a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "50491933a4958b0575ed46b364d1452742efbbd11a3a25e18307c0d23fce2b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b662159f4602e0636d3081d3787fbaa60456ec1690ea8f5dd24ca5b4f88f935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "972408c9352769432d7bd7717387f48d3ea937244e47fc67002b7f033a27624b"
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
