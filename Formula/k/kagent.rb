class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.9.12.tar.gz"
  sha256 "4cf093d49d99e10804d3659cb178720671b406ca3cf8ad6da011f62b08eed969"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0782e41ff3056b60338f8bcd6cb1594e7e7263661667e73b56590ec6bfed6509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0782e41ff3056b60338f8bcd6cb1594e7e7263661667e73b56590ec6bfed6509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0782e41ff3056b60338f8bcd6cb1594e7e7263661667e73b56590ec6bfed6509"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb5b65006f3812ff1fb588992ce46e5d596da2a49616f43d449bcdf8e5ee7c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63b6ea28cf7d5e8cf0e7036c92e29b637ef6ec19964668d4a71462f090651951"
    sha256 cellar: :any,                 x86_64_linux:  "5846626cef91786d11b3eab117401be1caad0e1c53bb193aba7d0d372b70682d"
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
