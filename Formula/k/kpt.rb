class Kpt < Formula
  desc "Toolchain for composing, customizing, and deploying Kubernetes packages"
  homepage "https://kpt.dev"
  url "https://github.com/kptdev/kpt.git",
      tag:      "v1.0.1",
      revision: "6c8a2e16f1f51605d6db9404ddea4f05db0e2aa2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    # Cannot use `github_latest` here as this might be "API" release
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        # Skip `api/*` releases
        next if release["name"]&.match?(/^api/i)

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "90bcbf92440da5a3d99e8c28dec9c9e3f83df9cbceac0ae0c358a92164e5c149"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb3dbb9b3bc622e40e9af0a82f42abb0486266833de06e815ea278227fb78340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cc8fa6ae26d697e411850b4b7a04ab3e4997b1dbf2e34eeb5dbf77e20b013e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d62c308af8ad0bb9693ff55c2e1b812c36d85093bf53091dad5d4888f9e603d6"
    sha256 cellar: :any,                 x86_64_linux:      "08a91b7aa2370f88346f4cf5126b605ae744fceb6d88719992b553a53562e99b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kptdev/kpt/run.version=#{version}
      -X github.com/kptdev/kpt/run.gitCommit=#{stable.specs[:revision]}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kpt version")
    assert_match version.to_s, version_output
    assert_match "Git commit: #{stable.specs[:revision]}",
                 version_output

    (testpath/"pkg/Kptfile").write <<~YAML
      apiVersion: kpt.dev/v1
      kind: Kptfile
      metadata:
        name: example
    YAML
    (testpath/"pkg/deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
    YAML
    output = shell_output("#{bin}/kpt pkg tree #{testpath}/pkg")
    assert_match "Kptfile example", output
    assert_match "Deployment nginx", output
  end
end
