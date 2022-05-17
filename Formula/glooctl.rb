class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.11",
      revision: "6781173bdd2ec304e3792fc74b52d14ffe7feb78"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c44ad40057f8c51401c21dbc30fb55ba589408937ee8b94234630e0e526d3e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7587fcbe7bd309c8eb2ea458b8d826af03d49b664ccc8262a9e59fed7ffb589e"
    sha256 cellar: :any_skip_relocation, monterey:       "306d64a371efb606d9141d0bb2e73ebeeff6429a852b481481c5174aa296384b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1be1b1f1d315186c27aeaeb5f38952c2bfde8162aba9fb1acaa9c0e1c28fcf2e"
    sha256 cellar: :any_skip_relocation, catalina:       "1b6f3439edd361cc81a181d67d076427b9ae4825e60fa2b86870e2020ddcfc2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8732e49373e87b1d16e6fd4ae7162c310fff280209d302580adf654f6f90b501"
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
