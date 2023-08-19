class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "683b735783a4c33d55ba67d22e0ff4c09b4bc66da56c138b59b23e6004ced349"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d9c8bca90fe923db7a1fb97b42144844abe3d2f2db19db1f098170147cf9c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "009b93918cd9b459a3844344fb689a7cd314c449232cdf5b7ab2ba0ca9c9d3ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203cc28c86bd197b96a2cdb000532732fddb969ceb50977d482d087dfdf83881"
    sha256 cellar: :any_skip_relocation, ventura:        "a142f2719086007657007e3964a6393862bcebb40583c7546391675bb7172844"
    sha256 cellar: :any_skip_relocation, monterey:       "0e5aabf18aea18a9f8e913ecfd0451716b794a92e4c0914ddb82dc7be746f5c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4427e2d25a8ea68703e02efb648af05a205d146a0c788582b2d1ca069430039c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd82684a99fe65d5c8416027853c31fa8c275ccfb2d334f356add0624b7b00b0"
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
