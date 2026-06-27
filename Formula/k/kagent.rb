class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "483083615a4f94b688da0f8c33f9f8e0749b2077acc9240657bfe938b834d43d"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "876a67bd7dff0719cd01381856a16096b8b10088ae8682d6626ccb1f32b8a712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876a67bd7dff0719cd01381856a16096b8b10088ae8682d6626ccb1f32b8a712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "876a67bd7dff0719cd01381856a16096b8b10088ae8682d6626ccb1f32b8a712"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc938d329ba357764332a5f166431ae627c886c4afa26fe43711de2cdd2dc33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ffa32597d3ac7e365d7e62854d91090a439e0f65e0eccb39f8105e5515491dc"
    sha256 cellar: :any,                 x86_64_linux:  "c07bf3cb96a4c591b2310bc3a69ea6c6e2e10921bf0bbdee10eed91d17caa974"
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
