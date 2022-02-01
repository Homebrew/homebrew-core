class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.10.4",
      revision: "ed4ab3169c21cee50a094ff0800720fa3847abfc"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5940e79da540516f598d798699fb9b1a20d7e748c3925238a536d7463b1132f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "550f96900c616b6c8084a258f6dcebecda66d7c22712e9e98cc04a5e3b144b63"
    sha256 cellar: :any_skip_relocation, monterey:       "f43edb3033d489bf2b30919275633b3dd11591b7ae96d2de5990a04ba09c55f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7842fbd4d2e84906879fbe056bfd5402a6de9f05f06bf9c407877422bf85781"
    sha256 cellar: :any_skip_relocation, catalina:       "ef7c95993f8d6f34831c13b0ae683ea27ed0eaa585b4ed9d388ae9588c33952e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406bd6eeceddfd0291f1201c04708721f2a350d58cdec53e7dcf631c32f21693"
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
