class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.25.tar.gz"
  sha256 "d8daf831e2926ca89e1d58880e7be43e01fcbc36eefd38a3bfe79d6c8d3e7fd8"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcf13bd317f6c21989edcfadde199002ba30b9b0295006505522c87883927159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eec3be2b04ae3cd046793eba2b7de34003902dcdd202e8ae1d03a159fe2c06e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b206367e470887b7d77564b4d040c77e518f13943de0e780cb3057a80ba62f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cd22703c10a03bd89c5fd880334bbd1703f66afee53a8d686712862556908f9"
    sha256 cellar: :any_skip_relocation, ventura:       "7f1a5353bcd6b4abcc41fdd76647864d6aa8c77c6388723569837471a1e3817c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf511cf4c3b87b689edeaff521d02e0d542a37e945d8e8eeaec3817de416ad3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
