class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a8c941e7992158650c69d59ae7c4f28c9dbb6605178321e4b6503e457284fbf1"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b90fd4ef84cf91eb8b6735e155492c6b092be95004b27105be3a75ecb5841bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a27d558e88269f8040eeccd695f2f7e405de72b2b2dfcff00a32a535aa662f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2324eb81233df73afcc7abcc9a8b0fa1b245dfd2c274161f0832a4d64cbdde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00230a35663c5c5c333f37d8e755b7560b902f0ab9ec1a89c4420aa5abf70499"
    sha256 cellar: :any,                 x86_64_linux:  "bb8fc9e24a26d06ede099f866661784a2cf3b16e0644107d9bd0a710b034702d"
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
