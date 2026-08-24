class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.12",
      revision: "469969f6bebf46bef5e808b91a4bb46fb2bbf4ed"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b217e043c415325369477086d85acd4293e776d88af6e15c80248be1b3aa7e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b87a6726add06826b2d26db97db683fbbd53948b61bc89ad8a50ced8c9c2f0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dde59f5ff0ed424337774e861980ccd6d2423ec60a0d45f4b90c69329aba9655"
    sha256 cellar: :any_skip_relocation, sonoma:        "a98ccc1d6425a25fe37b90e49dc541d99c140860c4ded4bceac05a8cfa99aeed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be94daa46614195b480e3b15db1faee6ad88dd87ffe71dcbd8666b21d8d487f5"
    sha256 cellar: :any,                 x86_64_linux:  "434120a5d825334e4c9285f677db951df6be402a7d1c2e720c0e88f453cc9c01"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
