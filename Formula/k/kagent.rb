class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "8ad37516b0234e394751982d77970092df0ab8a57628809ffdf03b2406e585e9"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "776ddcd6b40929b7bed167d18e289cfd0b44efaef821b06713f7a268d5b1d180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "776ddcd6b40929b7bed167d18e289cfd0b44efaef821b06713f7a268d5b1d180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "776ddcd6b40929b7bed167d18e289cfd0b44efaef821b06713f7a268d5b1d180"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f8b4140b58e97efceae75065c8cde5fe8889941fc462a3b1884de77cd75f780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a31a526a5ad571773e3ada75764ff4c7c7df7de950cef4336211cf51c1d2013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a94937d67ae30075fd2316d7574d350b3d4ee9bf9a0af67cf8c2f711ed53b71"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/core/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/core/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/core/internal/version.BuildDate=#{Time.now.strftime("%Y-%m-%d")}
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
