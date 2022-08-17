class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.12.7",
      revision: "db46b871d4f1eb9456e567f72fae3ebe41ed5290"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c88d0d88e3289e93d0e2a4531e83a414f16ca31d329bee3c11c28f888c035f83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee715cfda548641cfd292afa644dfbd84480d9f10ed4f62e45cf895bb6ac8a14"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c9d74a80276dc1a257c126d3e2cd95d56d000bb3a57a4512656adb713be5fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "94e9a4bed726520b41552cf091cd3b82d670c400957238a0812753f25810f255"
    sha256 cellar: :any_skip_relocation, catalina:       "8697a8e1bd4a0f70710e48918f5ec8716518d8d3b036a4fb67e1f8e0fd5395bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd39536ca58a03123784403e0b084b074127fa82dda5b07b32f551e98a0e7d0"
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
