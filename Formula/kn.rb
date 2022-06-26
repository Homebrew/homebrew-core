class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.5.0",
      revision: "0646532018621d3d08525edf6e47a125cf58438b"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94d33b9b5f61f5da57dfdd7c4c2cd3fbf653b9f8fb47f1fd963c0f5b4f585542"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94d33b9b5f61f5da57dfdd7c4c2cd3fbf653b9f8fb47f1fd963c0f5b4f585542"
    sha256 cellar: :any_skip_relocation, monterey:       "210d84300356a5a75f193bea1bb9a4d3f5a4f23739ccb96a5a8e03f665474155"
    sha256 cellar: :any_skip_relocation, big_sur:        "210d84300356a5a75f193bea1bb9a4d3f5a4f23739ccb96a5a8e03f665474155"
    sha256 cellar: :any_skip_relocation, catalina:       "210d84300356a5a75f193bea1bb9a4d3f5a4f23739ccb96a5a8e03f665474155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11c464196707fdabf4a7cc3b4d161fd305cdc1f72559bbcd1a05ffbd8684bb7"
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
