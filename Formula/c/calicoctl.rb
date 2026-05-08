class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.32.0",
      revision: "eb1cf57823a1dd8d25c48b82fd023ea9e3e17996"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f126d674e05fd4e32f30b300d3183b46f2fcdf71502d268913a6a454807cf15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f1ba5bc429e320f7082b76c05dfcce212dbd598fb37c009ed91b5fde785956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd59d61b7a8eade2bfca9818770affcfc368ee4f2d6eb5e2472864fa2838b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ee190f9437f4c75dec66ee9363510882ec49e29792e05ce93237f10efe37f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da185d8ff1752d45d5140ebab3d989a6ef142e72fcd008920d2348a104abb610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a455aff24e4124e1a1b9034595d284eb48778a034cb1139ee665312e5ba6eb"
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
