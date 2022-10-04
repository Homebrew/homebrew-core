class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.28",
      revision: "802f24b56ebd2a88741a58b13dbc1033301c5c36"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23867dbc435f660b7418948a9eaba71052a2b5ac2b2e9e1a1b570561e2ec5761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca1366515a7a3595c63e179fd48331fd54de2704dd42923bda3ecd5f3201d042"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf2b6e1123f6f5f02f87e9f0086dc4a647fa80e4bc84b16806e17311ca504ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "7df5a4007b375561b83a33da9ad542170f77b966f148ac9a57d799d4763198e5"
    sha256 cellar: :any_skip_relocation, catalina:       "dee67dcf15e0f415b2cdd6821a7ebe113ccb0e3887f594fdf923fea7764d00e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06db3eb690803cc4a749e4ad5a5fec314e4440b4297436705393dfa37cea679a"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=v#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"v#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
