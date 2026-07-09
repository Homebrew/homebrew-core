class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "f849d9d275a55b156ec4099cbcb0bf2f60d448142aa029146d42ac83f2dd8a50"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf04006289c679fd453194a90108e141f90e8861ca251d6c58a56a87a85b9529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf04006289c679fd453194a90108e141f90e8861ca251d6c58a56a87a85b9529"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf04006289c679fd453194a90108e141f90e8861ca251d6c58a56a87a85b9529"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dc5c86d4ea7c1c82d315c10c1bec5388c880463de6f8f573f4a4bc54f9038f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da86530858364c3f41e66ce01d3604d12bd40657fa980359c4a5b261a04f57b"
    sha256 cellar: :any,                 x86_64_linux:  "e204b227bd3809af2572d3972e1bb5b5a0047e0cfc9a05c653b282daa12aaa74"
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
