class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "cb7a46199b4f404eb89588789c0671155f5d7e92e58b3a6e994fcca276023fc3"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "869be23aaf9f9bb6edd33f569e25c0d4dff7f16495b0aa1d6d819d8892cc3c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a222875e9b3766e2cb90eba5aa4536ba0b39c6c8c4ab699ce2363b98e26841"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0d064e1d5c32b08739ceef2b54d1ee315628b5fdf434fba32fa9d7d3e833b68"
    sha256 cellar: :any_skip_relocation, ventura:        "fefc5068dc178fb261fb0f530454e6681fbe70c95f2b68bb95b7b9c2fa402963"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7ca0ad26beffaf25f1c304b403fe3f57d46a6e5886d13790a49791a128cecf"
    sha256 cellar: :any_skip_relocation, big_sur:        "50fb9ad77b2053952164894958576eeab005a536c18e55a613ee569f584ef163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "758f6539c29b02185b7ddf349dba8f161f01fc74166ebe3d069e25fa06520a07"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
