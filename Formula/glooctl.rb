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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "951f5b7f10c2968b5ed44dcc172223cb3188f3192676635449a3a37875415b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c43007dd6637d67b204bcd9f1c6c0058a0953bc22b5f61e648b9339e8479182"
    sha256 cellar: :any_skip_relocation, monterey:       "c331740553a56013ea23f314af1cde9f40669dcef8f095308fc565442ec7e79b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d4ce75f05467dfa8706818fd281a7b23d87fac2e5c76b2ae8b34fd688595145"
    sha256 cellar: :any_skip_relocation, catalina:       "3b775c4ac67264a97a8117a1cfbd3f907f4f368c82877be4696d9e2ee612fcc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0684a4a59da86cfbc1edf87fc1e7ffc10f8c8dcfc0011df3b8b42b1c7cb994ac"
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
