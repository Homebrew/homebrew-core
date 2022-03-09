class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.13",
      revision: "e8cf5bf4e2b027ac211bd1a807ac180c5f44d577"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2fc8398b64c575bbd2b738ea5ab4826d8a7b627b17c5cff75e74c5429b7fc65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d26f1d8a1f7ad7706600c24e36ce9eca4e40fe3ba03d18e0b9d72807d2dc1ca6"
    sha256 cellar: :any_skip_relocation, monterey:       "361ce71eda455a1f3e350cf1f9e694de91b906dcecb5c5f5476c71e326ba37ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "af335f65f38cd977b20f5303dadc5105da2512b453c5482e532f0fe8f44ca6ff"
    sha256 cellar: :any_skip_relocation, catalina:       "374911a6a08289138a5b422345d64f66e120afefd502d968a248a9983eaed25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7bbdd4c703c69c5b622a51d886ee7da651431324f36ba0b5031f854fb5210f"
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
