class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.35.tar.gz"
  sha256 "41f05a1821b5311bf3b7514056a82b67f68be662da0a9b89886ef12ee2c870ed"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af0cb9d1b63d1bd0de5b959a9b2b965dfa119b9faa38fd765fff66b568702b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79647706c824a3c8d077947297996fe47201aa4148a91840fb7781a0834c74db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b086d36a742325957c9aaa293c670d4232e56c50a6f56c24f11060e4920951d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1a2c6c8b1afc5ea144b938bdb8cb9c3bb6f1decef743c61076221d59f2a0f8"
    sha256 cellar: :any_skip_relocation, ventura:       "ad94a2c3453828c3fe67094759ffbb07d8fb7b057d1f8e91f2e805762edc36f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e4c501058e0f39c7add15a46871cf3da2dae9aa4f8aade0d8202b26c65546c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de4ddc605040cfefe0cde10f1df7812f1633dce7697fc3aae5b7532585e799a"
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
