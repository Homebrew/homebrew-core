class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.17.4",
      revision: "edc84c4f28c6b28522b449bdea2b79466c5f1cb0"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6321016c9e5872c2ebe1663865d050273e8474331dba3d476087fdae5825bc99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbe372a0c3ffa9ce0067885fb3a3505843f6ac3d605167ca5ad2b6d2dcf5c525"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "006fd17e683afe1413d1f1aa0ad538a3a29f85e2ad5fdf41b3e4539abcd52b8e"
    sha256 cellar: :any_skip_relocation, sonoma:         "67b30c2dcafdc779f59bd6b472a26b9383a6533731ed3727998bbaa0a2c820de"
    sha256 cellar: :any_skip_relocation, ventura:        "8ef5eca77eae9186525a1270d72e9429dd99724c672fba925f75ebdc789b8d97"
    sha256 cellar: :any_skip_relocation, monterey:       "bc3f8369d6a07af2cad43208a71035f3b7d9ddbc84925a0fabdef2c03cf19da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63038d952f8fac3ad03f0889b4257155dade2caa83a86f1474d01a0be5f04e6"
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
    assert_match "\"client\": {\n    \"version\": \"#{version}\"\n  }\n}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
