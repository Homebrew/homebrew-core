class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "e2732be8a92919a8e247abcbfe825df75fbf29dc208609c2f16244880e26fc21"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1fef5fc523d757a9ce133112aa967b500d25f2ef34eec9278dd62798ec2743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b1fef5fc523d757a9ce133112aa967b500d25f2ef34eec9278dd62798ec2743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b1fef5fc523d757a9ce133112aa967b500d25f2ef34eec9278dd62798ec2743"
    sha256 cellar: :any_skip_relocation, sonoma:        "89800a17d943474effc979f946f7784b080b95f16acb815fef33b50015fe27a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba61bce8420bb05ea18e3fdf1579b095cc73f300a3ee76ff10f1191d18f780fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4dc8a30dfca08cd319f11fb04ced1d08cc79d1bb39146df889f4f73b938d6e2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -s -w
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end
