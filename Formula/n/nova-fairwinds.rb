class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.12.3.tar.gz"
  sha256 "73007e27e4b60ccb6aa3d4244e53e900f692f830571909b45cf42cbfc6b58cab"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f76da790e50c65efdb09e60694c6282a65d0c3fd2c6780fe8f6c67787490194"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f76da790e50c65efdb09e60694c6282a65d0c3fd2c6780fe8f6c67787490194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f76da790e50c65efdb09e60694c6282a65d0c3fd2c6780fe8f6c67787490194"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ac1bda495e60ba06c07e557bd3c287705c1379a15b0943585c03931ac9e7df6"
    sha256 cellar: :any,                 x86_64_linux:      "f6a2b56c38baf9de07cf782db43a96bcea8c4b68743da79a431436d1a8cf76e9"
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
