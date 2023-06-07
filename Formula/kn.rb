class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.10.0",
      revision: "46dbf661179dcfbcebcf2ccd7c4c3f5549ad68db"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94b4499843da2260af16cc64003f30ccb7dc7e909b2273aec3ccffcf00f54102"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5818010300964b901e0d9aca0c94680bb6852b558cb7edf5d167ac89d7c6f60c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5818010300964b901e0d9aca0c94680bb6852b558cb7edf5d167ac89d7c6f60c"
    sha256 cellar: :any_skip_relocation, ventura:        "b576a658fe2cffdb76bf89eafe79e0560e988b61e32e7532c683626dbe329291"
    sha256 cellar: :any_skip_relocation, monterey:       "b576a658fe2cffdb76bf89eafe79e0560e988b61e32e7532c683626dbe329291"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bfd0bd933369baf16cae5178028121161de17a2972a3a6714c82a4ab6e27d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6017eec440698b5e1b2719b534a0d2f5cf736261221d2dbd4967e0977fd465"
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
