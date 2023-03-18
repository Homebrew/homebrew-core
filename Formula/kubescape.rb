class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "b97bf46d0f3257152679d272f1d995311525072f47398cece785e480d7246a25"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ef883b7be14ddeb039b1930f0ca200b4b6dc9811da91dac750b2a7a7711ba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552c88ba970534628bd707923dbcefb0818cf18c1dbadfd556c12dea9eab8bcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73483295f0ba80adeeba926b71401d3606dd9930b7194e7c63a470ac9815b72a"
    sha256 cellar: :any_skip_relocation, ventura:        "9376e64314d86e2f21ca8c2f3dc0d113fae66c2c8693326b0c13b0ed128b072e"
    sha256 cellar: :any_skip_relocation, monterey:       "58a9429b604d4c8e534701f487f20d1bbf1fd583b8abcff4289e2bb09a9bc7c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "abd0ff7cff625ec195a671f06b52b634f440bda0841caf03f3dcfb66a88748e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3957eb14b234050be84bad122adb8fa393483e5aca5fdc403d9d80a2d9836137"
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
