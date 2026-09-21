class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "da817547c5f2992d52abe7c13be6d6d7c56535184392aa76739a46ad5978b2c6"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  # TODO: remove if undeprecated
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83bd97a6deebbed90593088c1339d88c6bbe738b7e5dc6ff1fbeae875a5e2a76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83bd97a6deebbed90593088c1339d88c6bbe738b7e5dc6ff1fbeae875a5e2a76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83bd97a6deebbed90593088c1339d88c6bbe738b7e5dc6ff1fbeae875a5e2a76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ac2e8adaf213abafcbf1d56742bb4145897e8b8d82c962f6961d63225f7ed44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd850f295a27b3f3193bfa5f1ca9dc0b733006cf4bb24e0da814ca00b2849cef"
  end

  # Can be undeprecated on new release or if upstream responds:
  # https://github.com/openshift/osdctl/issues/963
  deprecate! date: "2026-09-18", because: :checksum_mismatch
  disable! date: "2027-09-18", because: :checksum_mismatch

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
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
