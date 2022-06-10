class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.11.14",
      revision: "0d4ebc2f3903ce14ccab4cff8f879f6a738d5e80"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81a51497f1deaf9dbb8646229790f9b3cb7013ebae81eaf70ac2be4783b570e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac2f25ffc67a3038a67282b52ec1c7c09c3ba38b92ec00287b7fc326022ac77"
    sha256 cellar: :any_skip_relocation, monterey:       "52b923f7d367b0ef39bed167ad594cdb8e51e605ea9bf19ebeca4ba6bb4622d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bfa311bc324b855e91e0839e00143a64e618f6773c65a62f9283ea65e256313"
    sha256 cellar: :any_skip_relocation, catalina:       "75c31442b4ec988acb6d12a33273955658834d045dc2ca6542a50e54d01ee7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e20a27bd6efc0c500eebb7789f95006c9c055c4f34a86f22645f344ba344d1d2"
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
