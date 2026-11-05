class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "6f59b03a1302978d988c165feb25826b746d40951d42a7afb201be11e9ad595e"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc833d764cf7810c365f156402ceed74e3d82cf478e6381c2c2a28fb0e52d297"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1fd33417d3486e903195472cb33fae6edca8d758577e6491ea895ad1e3a8e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c943bfcefbddbcd28650bbdc135cb0d481b74f5df97bfd1876f1a86a397421a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f310b40fbb37c520bfb3572801a606ec5c95d9f06fa79ba6c7c7a3fbb415d122"
    sha256 cellar: :any,                 x86_64_linux:      "49cc1a673a643c3d50127d5918f6f60bbb59b79876c08dccd7d039dad4f83f62"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

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
