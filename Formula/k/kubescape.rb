class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "706ad57393f557f7f7e2db36c21a3c114172ebec981819e67ee3e4f6e2b3e641"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d84bdf98344ecf2899001f99e9ad142f7fa228652b03885591914a389f4e2d4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964c86e9310960ffd8bef8bbcf5320dc7e0b158a3902f3b1a7c2f3e5042ef055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "245c7d433d00a3ea2c36f76fb284bcf45f5715b0a1332b7b9f5888c3da5eeb91"
    sha256 cellar: :any_skip_relocation, sonoma:         "50d1e94be792bf1b573c7f8fa5168310542f4aea762d26308c8b173b7922fca3"
    sha256 cellar: :any_skip_relocation, ventura:        "72983d71b11abc79cde8605812793cfd0a374b50b6e550a9e48d9f0054cc5ac7"
    sha256 cellar: :any_skip_relocation, monterey:       "40ea2bc45db7abf5d2dca7e156ef5abbb3683372375a96d522fa310b001d483b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "752aa16c3a71259efcbc40072b823e6851c50664f5a4004de530a7ebc958e92b"
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
