class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "64a052920de61fa8026a7b539bce0e0b51e01fc17f72eb48655f9cbf87f6f43e"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1553eda3ce71ba36c0ba00bf45343c5f366094729ffe6c28af9dd196fb7668c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1553eda3ce71ba36c0ba00bf45343c5f366094729ffe6c28af9dd196fb7668c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1553eda3ce71ba36c0ba00bf45343c5f366094729ffe6c28af9dd196fb7668c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a204c91b9c478db1816b20e59d298f063b9c39be0463c071618714d4d4d29edb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62fc89ea2f79c490d8a2d69e82dc414b31e276c2a3ffc8a6f0ebef3ce5d9a630"
    sha256 cellar: :any,                 x86_64_linux:  "f40329b0da18585236515ac169bbe7c58e2a02b8aa41455d02ecda1862e269c8"
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
