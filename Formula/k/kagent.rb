class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "de6e349fb5ff62cbd29a392d2bb649bf199ab469bd4ebe940f37c9af6f386912"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7f1eaf175098278cbced6edd90a85bf8045b2ca436d3ea4dab48380def75b65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f549ea523c483b0783d08fb071bf6fb11e2271598c5622a0b6d570f05d19fc81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "103827ac3b499860dae3b09d4bd1d1c9ef3107f7dea010deb046368fafe770fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1b9ceab9d2139dfb25844775dc184ef7fa8132a3291b20bea0880ae48114c3c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a1781e310b5bffec0f1cb61091efa74b9e16e582e655be6a4b3335774a27423"
    sha256 cellar: :any,                 x86_64_linux:      "3e173bd29064a39044851fff5179d95c488ed42dfdaeaa8e25080509b5718032"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/core/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/core/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/core/internal/version.BuildDate=#{time.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./core/cli/cmd/kagent"
    end

    generate_completions_from_executable(bin/"kagent", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagent version")

    (testpath/"config.yaml").write <<~YAML
      kagent_url: http://localhost:#{free_port}
      namespace: kagent
      output_format: table
      timeout: 5m0s
    YAML
    assert_match "Successfully created adk project ", shell_output("#{bin}/kagent init adk python dice")
    assert_path_exists "dice"

    cd "dice" do
      pid = spawn bin/"kagent", "run", "--config", testpath/"config.yaml", err: "test.log"
      sleep 3
      assert_match "failed to start docker-compose", File.read("test.log")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_match "Please run 'install' command first", shell_output("#{bin}/kagent 2>&1")
    assert_match "helm not found in PATH.", shell_output("#{bin}/kagent install 2>&1")
  end
end
