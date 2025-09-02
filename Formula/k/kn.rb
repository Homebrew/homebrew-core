class Kn < Formula
  desc "Command-line interface for managing Knative Serving and Eventing resources"
  homepage "https://github.com/knative/client"
  url "https://github.com/knative/client.git",
      tag:      "knative-v1.19.3",
      revision: "091f88684b9cb1d02e2ce8594e71ae7e8f452c7c"
  license "Apache-2.0"
  head "https://github.com/knative/client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329b030d6ee147e90548a5344b432675abb798a19c373a55718be694edecf5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe66103e92069e09de075fd2e758261b8ce849f586e608c79050eb7a9ec8e350"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84ab4d8c7f8e8cef8b73f5a7f86d6ec5a55765841e5beac4c770d1cae01f847d"
    sha256 cellar: :any_skip_relocation, sonoma:        "906861402fb6bc7534c56cc826c564b19c719a51eb661a0ec720d80cb7e5be35"
    sha256 cellar: :any_skip_relocation, ventura:       "15a427a7e293da85e66cd4224542223401c395fe947bc082477c6d44322b085b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d7604be226246236902c416703c0d51fa798f2dea309325226e3bb39c856f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "655864457ae3652159408b1226bd1680d587e65d45b97c46ee2836e1c6b8a576"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X knative.dev/client/pkg/commands/version.Version=v#{version}
      -X knative.dev/client/pkg/commands/version.GitRevision=#{Utils.git_head(length: 8)}
      -X knative.dev/client/pkg/commands/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kn"

    generate_completions_from_executable(bin/"kn", "completion")
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
