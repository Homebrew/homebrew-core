class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.45.tar.gz"
  sha256 "cd1e172de81119c94602d6634dd8a255427f2d022f1795d9f6c605ebf969e78e"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74ec07a765e2fdec00bbc1a17b9d0f6a6df2658877672a2a8b8efa881fd29aa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11e28e942823d88852c2f5b0db7974f15a3e8c2f76c4cdb8fd63b67f751d1d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "009185454429b34d8f1b2916ba03212cddde107043bb588c7ced07b42b6bb901"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e65b51b7ad800560bfd255dda8e89376b38104bac20534989c66faf6fd2d40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e66c34de472ab8d7448c51f83090eb92952f10b6683d5d6882d688bd2ddb6c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07ea9805f593c7a2bf48c2409a3ef56d71b56889f6334a201c2946f511e2334"
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
