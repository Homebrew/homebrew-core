class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.23.tar.gz"
  sha256 "67c2aff4d69b3de3cd57b11d530af2d1a4f64c57cf0a769f71732cd1773fe330"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a5baa236d071b94fa492ad2e2110f207b313032a8bc75817e419e9ed3cfd56e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a5baa236d071b94fa492ad2e2110f207b313032a8bc75817e419e9ed3cfd56e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a5baa236d071b94fa492ad2e2110f207b313032a8bc75817e419e9ed3cfd56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f860d7bfe8f41411195467af8b4052e7fb548d688c6e69ef689d67184cc59a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85cf2ecb3e6b59de4ffca13d4ec6baf409cc839b01d428109327d6fa0211d3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0be35a05ccdff00f1218f5bdff44b46d3266f4b8be566a4e1748432b1f09b10"
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
