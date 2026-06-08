class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "efe059200aac39043555b30ff1e2d571c862353f0006a16598947b0ebb1747e0"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eacba500bffe864d1163db8717283e39eec2a302b2caaa0536ea3a7a2301013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eacba500bffe864d1163db8717283e39eec2a302b2caaa0536ea3a7a2301013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eacba500bffe864d1163db8717283e39eec2a302b2caaa0536ea3a7a2301013"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d6a3f6fdf416f768b432454245076df471f14b152004e50b4fab87cc30abdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ee29684bf9306920bddaa98d5230d87479742cf2e69308091423a6c3e2cdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8bdbc07becc40cfaac7b58d843fe498389661bf3f374e52771405ff43f0313f"
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
