class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.5",
      revision: "1d5520f7293f418dff829bfd7ed75b1f1867ea07"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a40b096e62dfe5a743244ec6810ae77371b31ff8d4f300a954c9506f96001a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5d79ea43970ef0c9c5fbe81704cb726bb1d1575453aa49f77383d316f19e5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd739c90231035731053d8dd9a3528752a76e3dd17e7637d8a93d7160b2a4159"
    sha256 cellar: :any_skip_relocation, sonoma:        "105dc2b49c1965397da620a9f8efa669fb0fcd56fbdab11924eaf387da63cc87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d816501472cb5cd6bd8bf7565a0ed4bcac1d323cb8d1849a2787a635cab1c16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01b168cd007f5c02e9fc246007f0ebdc5f9a6fe3edec5bfb56a64f624fc13147"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
