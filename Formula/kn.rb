class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.9.2",
      revision: "ffbb229e46be9a01d0f97a4d6ac8b67253dc2909"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d734d9cd964575bd6426243ca2fdc0d8a9bd0c15cfd322d94b3831dbe76131a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d734d9cd964575bd6426243ca2fdc0d8a9bd0c15cfd322d94b3831dbe76131a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d734d9cd964575bd6426243ca2fdc0d8a9bd0c15cfd322d94b3831dbe76131a"
    sha256 cellar: :any_skip_relocation, ventura:        "eff14ef46cec4ed99e6ee0efd74c001b898390a296abef228c9c8a0285ae39ed"
    sha256 cellar: :any_skip_relocation, monterey:       "eff14ef46cec4ed99e6ee0efd74c001b898390a296abef228c9c8a0285ae39ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff14ef46cec4ed99e6ee0efd74c001b898390a296abef228c9c8a0285ae39ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4005cd9229bab2af5a1d26da4b03e4555c68958f1454289fa9c884e648eaf36d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X knative.dev/client/pkg/kn/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/kn/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/kn/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags), "./cmd/..."

    generate_completions_from_executable(bin/"kn", "completion", shells: [:bash, :zsh])
  end

  test do
    system "#{bin}/kn", "service", "create", "foo",
      "--namespace", "bar",
      "--image", "gcr.io/cloudrun/hello",
      "--target", "."

    yaml = File.read(testpath/"bar/ksvc/foo.yaml")
    assert_match("name: foo", yaml)
    assert_match("namespace: bar", yaml)
    assert_match("image: gcr.io/cloudrun/hello", yaml)

    version_output = shell_output("#{bin}/kn version")
    assert_match("Version:      v#{version}", version_output)
    assert_match("Build Date:   ", version_output)
    assert_match(/Git Revision: [a-f0-9]{8}/, version_output)
  end
end
