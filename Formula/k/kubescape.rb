class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.47.tar.gz"
  sha256 "1d8c4820f341823dc1fc50d575044099dbf5cbfe2a05fc9e12976715efb41ae9"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02a65f49275461aadf9838f091fe565d9e6223fdae4c8de6bc6f0484b533b4f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8052bfa6ca69ce5a2fa5b6e825021bcb0b16cfd067dd258d73ca5977a4f5205d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdccdde42d095f15666cc5f322f6bc902aae05fcecd949fb251b3dfda546a747"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af3cdb6659629e89d767c2af6d2bd5d993291e02e73943cfda881b7e7fa55dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d70ef9c71d07c6a43a27d57f72c8e5d7979f899d1d41a25cbe262ecacbd688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf33bb0738dbbae9ecbe8aee6ceb2da00533548f89b62266eaddf1c12294b44"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v#{version.major}/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
