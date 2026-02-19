class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.2",
      revision: "9aba8e4534913808434e9bd1d8981f6e7fc17e8d"

  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab1665abd9ed9a6f954616b391a376c9c94cbb725f82fbf7ff830d699cdefaa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878e831a6a9d7cf0ce5adc3cb2cc862a5217b28bb2340be4bf1c5108b313a767"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e3e85e756e704c82bc21d88c0064ccd0b242ed8d7269df7ac0c3ee8f1558ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccacab624ca54122163304aa5379514c2c52af5cf13bf1eab576aa74860ba6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d95229c746ae5bfb9478be814c525874114e20525272ccae967be3fae629e0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fcdb3b9fe07a2c0f587c60a958858e4c9ab1e99e470f6a93dd7d27955c4530"
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
