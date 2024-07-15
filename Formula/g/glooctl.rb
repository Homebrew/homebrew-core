class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.17.0",
      revision: "751e637199edce4affafe8b040e73a5a02156fab"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d89d8e7a2cba0b0d1ee3ea049a51d1f29a4cd51d1e3cff53a63c44357d89ac1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3cb9852bd5de3ad12f908408a39f14bd56d7f126830c1bcf4a65a518d62f56b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f879a09efc04ffc8cde1fe4e6f46181f465597e782c339bd49e8370de9a7603"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a6b69bfea7ae9bfabe1aa695dd01db93e021f3cb29c5b02507acbc80118572c"
    sha256 cellar: :any_skip_relocation, ventura:        "5d30a5eacb96ebf1d3b98846fc67d3a9f08a847f61f8d8e65a0c36acba3826e5"
    sha256 cellar: :any_skip_relocation, monterey:       "c9f58b24b11117a7a6fe817d3fada819d54d75afc6f8c18ca85af69736deda69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63da213f5932630e28f74a4956f56ada07e2b7c00bcb4cababb9a4bea4bb5d79"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
