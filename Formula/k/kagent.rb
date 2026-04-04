class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "7e5812b1219d8c6e3c457e83bd9250ffd17b92a8be4d62859c6610e3a6aa5952"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c7800934bf9030e063f061fc5536a9bd724333d65498acc77cf9510646bd749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7800934bf9030e063f061fc5536a9bd724333d65498acc77cf9510646bd749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7800934bf9030e063f061fc5536a9bd724333d65498acc77cf9510646bd749"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c73c566307fb999bdc36b67e2b13e144a2a3b46568e62d47cb155607865936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098e53e04e528e6afd52b64f3797d67d9ea47312536a2268f1601b47e8ca2829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552e8be3a030b7dc3db6c51c26cfcb1d0dcafd3fb300c051beafea6202c41504"
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
