class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.41.tar.gz"
  sha256 "21006891f86b1bd20aa49829cd4f2e61daad2577937807bfadb12a082b1bec06"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4f6ea47134b1bce7b9f69b9fe18c9784eb13d384736fddf7446b1f13f0b3831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5090f1577e902d2f1d7de77a65d548b1484d6f4539ff71ea2d7652c42ba13fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca792b93166fb30e18805d8f03bc2070dbe769a3d80cbaf4b1ab69ba0b12a289"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e52a569fa7ca3a13531cd867766c4a8291fd9318306785378cfca953f7b0db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d47b1d223537ebc46650a198fc089fda6ff5ba77c67c69530840e68ab0d4e239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1087689457231167b5790d3a47ffc447e1bc195408e8e9170ad91e275172dae9"
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
