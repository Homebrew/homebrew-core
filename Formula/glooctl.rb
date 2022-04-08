class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.1",
      revision: "39f4a30d41aab5c8c16eee1ba80280ce78ab7143"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e868d8034f8f43a3fc94c87b26828fbc337c6c18401fc8db7e4c75c31a0029b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dc7f8393cfc4c5c2248053f77bbe828132ce762fee0f98cba3e43ab85e9ff81"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd2d5ef03187db2626bff742760f999ca93e03ac142d3093368f06b893e7df7"
    sha256 cellar: :any_skip_relocation, big_sur:        "27c1ae69629838faaff74c29516fc58fa679c99884ff72c2a7fc4bcc09692e05"
    sha256 cellar: :any_skip_relocation, catalina:       "d4d96349093da20715b1889859d8a33e2fdca0c69458008282d7c9ec769e4b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddb3dceedee553961068e659360dc267b6931295e49b915158e41b130c978ca"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "TAGGED_VERSION=v#{version}"
    bin.install "_output/glooctl"
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
