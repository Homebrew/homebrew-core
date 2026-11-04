class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "396a13ff1eb03fe8093c2900617455124467742d9f3ca4fd19a87d589dd7411f"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "486263cb0f16cf8fbce2dbea5f4b022bf40e9202292b155b401d2ba52aaacaec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8769fc58a0d59dedfef15fde3786888bd2cafce9a2d60db2d5f700fa8040e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d4503aa7c3e9280f048a7c459c6e043e332bdbb1015e8b720e4052c35291b92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2986c5b407ee31c080e0ae97e6ae82be23d927f2e276d206fd03e79cdfe1e8e2"
    sha256 cellar: :any,                 x86_64_linux:      "c6be86c8824b8e2fab5141764cd4f97e999bc1a583092290773004e8c36eca5b"
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
