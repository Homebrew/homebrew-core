class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "e5a83ca07025b6428fa79b9b664cbf83dcca67013073074bc044f289adedaab4"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a53707e09776c97d944967324e45686166f996e486faa93cb5efb234ecc98e03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a53707e09776c97d944967324e45686166f996e486faa93cb5efb234ecc98e03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a53707e09776c97d944967324e45686166f996e486faa93cb5efb234ecc98e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ba0a714c11da30e39e98b7135b04d8bb6e601adedfcd09829e8ce70e249a3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c2f28864b6f1c26f4da7d63572b19a470aafc759788d837d1a4e1e9748c5b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ec6115d2315cf0af906643d98db77cf2d2e994e9891a1e5b73d162914e12d4"
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
