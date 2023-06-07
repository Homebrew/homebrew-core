class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "c4ca222be7739c2d2f30d352eacc9d69a0601ceb96f0740701b49cfcba6a2aa8"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77d108cd9189315cfbffeaf6dc26896f9fbd86f148654dbd529a327878466c4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9effba1fc432ea5cbfbfe4ab04b02d4e7cab535c86a9511efab086f83ad8d172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caf6d0c0518017de980cf1d9b6b42150557dbd9c2035e9c721ebf7c551cd0f91"
    sha256 cellar: :any_skip_relocation, ventura:        "239a712b9c08714d59340c62e0a51de5526bafaec8b976b69cf4f613906a573f"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a6c842cbc508b73a397b9e369ecf2e2321f4a18a0909327eca80c9b1ba98e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d08c3425e539ca29093e40a95a83fc0c139fea6d8f729de42c0cfb15f3fb4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f9b3e40465eab656efec3fae555a8417025bcf49a55ce649e65138408f633d"
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
