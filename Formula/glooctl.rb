class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.35",
      revision: "67640c6f0514a2379143f7337f086a31c7985fef"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0be3009645150688b216e103541b2886c04e922d9e61138fe9bc421a9ef32e57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e1f80ecd8358bde5ee8ea61e334591446232e304354f6ae8156440d150a71e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3671f4ed3c1458fa275cb873b35b7c8e4f815fc083f2a449852e2c52fd66c7fc"
    sha256 cellar: :any_skip_relocation, ventura:        "15a3b2e8a20ca2c2fd57b2464e7dbb3e479c0b70f772245e780e6c4ed207c928"
    sha256 cellar: :any_skip_relocation, monterey:       "53a5f4973bce81a279c941e3dd0dd8fe06f19317fd7205a09d32df3415fedcf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2785a1ce4ca6831d5cc9b718de67cf7746524d6b1d35fdeb473cafbee55b0674"
    sha256 cellar: :any_skip_relocation, catalina:       "e90bf3ecc2660fc8db6cbecf67af4ef6ac68417d55cc25890568f6cebf460e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f2f5ca35f561d5de97b3b38fbe2bc6a19d4275c0d38f1dc3a3ac8135745afc"
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
