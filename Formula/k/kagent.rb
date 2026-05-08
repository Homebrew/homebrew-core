class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "1c0e7a0b3d6c2cf0336171da8f4752bfd7f9adcd413cba25ce613b6ab9df917f"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e2348b9ba0088424f717508db1d780d415168830adcb13a3486e8dbf69f6e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e2348b9ba0088424f717508db1d780d415168830adcb13a3486e8dbf69f6e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e2348b9ba0088424f717508db1d780d415168830adcb13a3486e8dbf69f6e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ff2040709a08e4ba857c3b07cf939b5fcb37983e5343f72d73519413b30b449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a946f48759489bd00db1ef5e0cf0b02b2b8d802d521e833b05e465e59d8f4477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5c3e170e89c46daa8d7776a06276cca27ffab3bc2ad417db8bb5b69c619d3d8"
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
