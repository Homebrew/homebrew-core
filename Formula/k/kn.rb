class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.23.0",
      revision: "e411e88475005c36abaa42530521065210c8588d"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa42c082218b8b828f4b1b32bef27c70177defaeb5bab1f8322e232c5eb54fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "002bb1f5bee5ced0408be0497f90d49180e5231eb4aa64fa263801e2281429f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9e1ebd135d62b449e6d717dc7fb5aec9e319800a75b05eb9101be4ea1f0aeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c93dc1d9fef9b153e9ffc7dd444ec17e550774ca02f8c0cac9ee9f8e0c07ead7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51dcfe063122ef3400b7d43e0519491f5435c67377ed81a84c7885265a45ff10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d780f9623ccb237493eb530278fd023f4b5dc79fdb0fbbd91fd377b9d8deda8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -X knative.dev/client/pkg/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kn"

    generate_completions_from_executable(bin/"kn", shell_parameter_format: :cobra)
  end

  test do
    system bin/"kn", "service", "create", "foo",
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
