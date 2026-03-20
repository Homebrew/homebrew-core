class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.3",
      revision: "b79488dca6a1e1dc3a1c602de082b0de47a32d91"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b20cebcef6c12d0f1c3f4b439ecf2e37f4a643c0589de5be028dc4bfc8e49f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63c2214b8591ad76caa8abb8b0c7f4a826642d749273c5dafbf7c8b8e3deeeec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589e645088dd02c5114f6ff47eef8d1a35a96b8be4318371f57d5e5eb98bcabc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7406ac6cdc6841d592d6bfae50eab4d07de30285fc30f3df54d4fb751a25320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1431c33bc95339b8727931baa5909574f274e8ca1923b618b231883d3fdf157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b007920e6c4e3459c945e8ecd3de543578cffdf02c36586f6dcf944f65d7a04f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra,
                                                          shells:                 [:bash, :zsh, :fish, :pwsh])
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
