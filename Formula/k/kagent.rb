class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "7e2bb34a4347c11151bc22cc2737294a0cc23f588bb23e7f938f0eae9253c5f1"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd604a58395fecbc8d02633489b51ad71ace63d4e0151ee3f49e4fc02c6bb0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcd604a58395fecbc8d02633489b51ad71ace63d4e0151ee3f49e4fc02c6bb0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcd604a58395fecbc8d02633489b51ad71ace63d4e0151ee3f49e4fc02c6bb0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7091c3b54bbbb7f68d2905159f237f242c2f647151d5f30f41a83ffb7099e230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a462ace11f5ac5c946983a9130dea143a19109249b8b42ffe0112fecf7da18fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0781ae12c9041b5f79465f0404470577a5289258d04e6a7683acacbd0756d116"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/internal/version.BuildDate=#{Time.now.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cli/cmd/kagent"
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
