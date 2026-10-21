class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.12.2.tar.gz"
  sha256 "3f8f6e1f6558e8ca2d8e035093fac90c732e67e9ee48528f34a85a3f6164495c"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da8998bd323d59a6df9d9ba77dc4d2affca34325ca2deed4c557fc516017f712"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da8998bd323d59a6df9d9ba77dc4d2affca34325ca2deed4c557fc516017f712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da8998bd323d59a6df9d9ba77dc4d2affca34325ca2deed4c557fc516017f712"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4560117e57adbf8c4886b951fd454379ba41da400b2b38081b1765f16fcc85cd"
    sha256 cellar: :any,                 x86_64_linux:      "9e614404ad314ed59b281a4da1c03bc0d5c759d49080cb972a729d2f11039b1a"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
