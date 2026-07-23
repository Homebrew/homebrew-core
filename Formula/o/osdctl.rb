class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "f6d0000bcae67bbf1658086aa468784afd406d20cf607d133640a0c691325af6"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a61bd42951d46b9611f84844a62e49526119e81cbe295d4700cc51f8f9e89db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61bd42951d46b9611f84844a62e49526119e81cbe295d4700cc51f8f9e89db6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a61bd42951d46b9611f84844a62e49526119e81cbe295d4700cc51f8f9e89db6"
    sha256 cellar: :any_skip_relocation, sonoma:        "372ceee700c4ffa038af8d3183322e8edbc53514087eeb2b5a52cabdae0e0b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4acd96cf501c122ee682af606f0f82bba0926649dbf76dbb6b49c5cb96659eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7159305f4e24239d8b12636cce2601c0bb660acc691eb6c5c4ac8ae8d0f26382"
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
