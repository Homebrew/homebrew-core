class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.8.1",
      revision: "1db36698e19b9015c215b9d12cedd0f196012734"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d0f217219337f5c68bd9cf73e4448e1edf120447ea5d13f5321c59b3be8944d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d0f217219337f5c68bd9cf73e4448e1edf120447ea5d13f5321c59b3be8944d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d0f217219337f5c68bd9cf73e4448e1edf120447ea5d13f5321c59b3be8944d"
    sha256 cellar: :any_skip_relocation, ventura:        "e6751d84ea0d2df943f91470468289b5770a62f057bf413dede59d9c79462a00"
    sha256 cellar: :any_skip_relocation, monterey:       "ca68a7ee211d70c48d19db197545773e9f580db9e23195718bdc4412a93526d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca68a7ee211d70c48d19db197545773e9f580db9e23195718bdc4412a93526d4"
    sha256 cellar: :any_skip_relocation, catalina:       "ca68a7ee211d70c48d19db197545773e9f580db9e23195718bdc4412a93526d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d00c9a42ab7cd78bc8c3c42e811928cfe85dde4d4c19a1876343fd17b5de3d1"
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
