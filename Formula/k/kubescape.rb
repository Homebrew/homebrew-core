class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.16",
      revision: "d0ea07bcd9d7ab1640dcd6527d0e68a34f10da0e"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2df177291de058ee1ecc9502175843f6d71d523e7a1a7e9f87cace9a6672282e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0d72fff50630927fa8d2b78e4f45f9dccb5e1f118752307c9699440bb6ae59b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d780e8fd560b957f2efd0defabd9b1b2f4ad5d3281d5746cdc2592c0f7972e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9756cc34207f8a418a5f3c098a4baf1b1c7c8d2311d67a4f35bababe92d42585"
    sha256 cellar: :any,                 x86_64_linux:      "9a2003b241a7c4bcfc972697034bb04ff06d2c2d6bb632eb04e1fd4a1af6658f"
  end

  depends_on "go" => :build

  # `test do` block downloads framework artifacts and scans a remote URL
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
