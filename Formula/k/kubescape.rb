class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "b58712f9ef8c270db9f8772f3cadbd5dcb6ee881850379e20f0730c38ce771f6"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cf0e288bbedba78c68fd85b388b0f37dfe65255f10aab3f48626c11489a69a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56ee84a4b7903796cee32b20ce303e4e779adc7e76142318835539021841af10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf7e13bbbc2a4b32475a000de6f4ac877442beb050665ebac5943c25c52a6e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7b06d7d9bc8ce835fa23d719b10dc83ce5eead4d93d28addec56fc22bc75ffd"
    sha256 cellar: :any_skip_relocation, ventura:        "85930525c09258ce1c92934d51157686464da14daf3a638ae88a2c06a2fb78b7"
    sha256 cellar: :any_skip_relocation, monterey:       "355cfde81bd162e68664f42b4b7849f531a26b5ab847d1da293aae5d71ccb4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b482f61f96cf5e3c5e1f1a9eede62401a80121c2b19b0e24db110df050ee98"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
