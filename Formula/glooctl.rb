class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.8.3",
      revision: "e536d8b9fdf37ef3e705b72cbc5930c53c78bb45"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "759db575c495e4630719850977f40044d47fa4cc9a9ab58d467198cfa25eebeb"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc7e061d9be105f60d1cba5c9909847dbadd62d24127121061e3d255a076c8d9"
    sha256 cellar: :any_skip_relocation, catalina:      "100016bc745fd5cdf6c18a2460bb9b4ebff461f72ec7a9754eb965a7d2c7336a"
    sha256 cellar: :any_skip_relocation, mojave:        "77bddf8073268d20ea3badb04d92cab6972e35ee3352ee3a9fc71f619dc1951c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7852990edcb9ebcfdb38f8963c50726c4a3bc29b2d216cc9f73f6b17e3ab723d"
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
