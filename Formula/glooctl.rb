class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.19",
      revision: "2ae44e598d479753ff31ec488b52552586622b0b"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fe45bd86fd82bbdb710e22dc5bef5645068d0366e4735b3fe31b4a844f73c06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fd2b8b8965f36cf3bffa4d6a3f63fe398ce3e17ea0d5bdd377e779c06b68ab0"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb8e87cdc0f2fe7370d6461700a7f4bfaa726ac5247247b07fe5f3551cf1dbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3de9b755bcfe10d8c130d1db25a29bd21c7f53027a4a9c2be9f0e5ced1273912"
    sha256 cellar: :any_skip_relocation, catalina:       "1674db017e4aca5ce1e1c0a11facfa98215ba3a2f0a2de76113b8fd77bbda0c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e75b0460c7ae4ecec593c18503876b37a5c81ad7db5475b9c9760461ca65a3"
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
