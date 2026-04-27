class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "08d3e1e41fa454bc86d393b121af96964f47aa34e7601620579267a1d422c87d"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06cc89d61874edc79cefb4c77479b7c8ea4e0524814f4fc7e4dde7d8ed6b7106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06cc89d61874edc79cefb4c77479b7c8ea4e0524814f4fc7e4dde7d8ed6b7106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06cc89d61874edc79cefb4c77479b7c8ea4e0524814f4fc7e4dde7d8ed6b7106"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0bb2727e2b8d3aec2e475eacc91f5377fb44175decd50e987b13d9f731ea5b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c41f259dd0cba233166eb270aacae88789674083fc196a02e55b26abe7a49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee038822dd985e1e8902f74875ee8f1ee34176b0f52eedd5f4ede8ece834580f"
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
