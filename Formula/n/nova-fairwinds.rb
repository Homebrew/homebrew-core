class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.13.tar.gz"
  sha256 "eba92fc698e0e8947b7956711041c72be564ce0d6e34ba8ef1bad5050a2e09d5"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39bc1c4d17a4dd29d082dd3e517b55e1d42646e498a4f483afa16d0af22f4d53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39bc1c4d17a4dd29d082dd3e517b55e1d42646e498a4f483afa16d0af22f4d53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39bc1c4d17a4dd29d082dd3e517b55e1d42646e498a4f483afa16d0af22f4d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb1d2af7a86f66eba7c76baffe485d2f72eafdfbf3cceea05de0efb4c5604ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df59d55ff95570965a36a6db50dc04b1e5e151316e2e9733b4a9196826fa8764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816541627ad4f242d41fb85b0199aeeb152a47ccec134a69c1f5f50f86c510ec"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
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
