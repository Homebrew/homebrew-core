class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "49a150a769f64894a5f91fc641ef7d491a1bb3433a63716d8ca7e2cc7d274f36"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6a71a7529095aa9c812aea57685bd8686a84373d71a949dc169bba6d8b3e624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6a71a7529095aa9c812aea57685bd8686a84373d71a949dc169bba6d8b3e624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6a71a7529095aa9c812aea57685bd8686a84373d71a949dc169bba6d8b3e624"
    sha256 cellar: :any_skip_relocation, sonoma:        "42aaffdb24071f954e982ddc11c5381e228b0e18af65f32792a801af3486327b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6ec73e30b1ebe49471ae51a848ad074742f90721910ef84007636e7cac7e97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53ff509779a2d8f105abe9f10e2325640585ccf9b648d7c280ec4ac5fd6b36f"
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
