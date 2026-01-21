class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "50bdc1bcfb6faf130b1f3d333ba9503c5e1dad7e5d83a23a741d39710bfdb266"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78b341b4ebdc20747b77d81485e0adb1ef467a8ec86a4978b4789d6300501525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b341b4ebdc20747b77d81485e0adb1ef467a8ec86a4978b4789d6300501525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78b341b4ebdc20747b77d81485e0adb1ef467a8ec86a4978b4789d6300501525"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7db947108163083402ba03940a2afa0a5ccbb8db662dc4493b5472360df54a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d009e18fa4f2c38ccf00cbddc18c88dad806d2d73969a71352ec7ed731d60ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12bbb81d7607dd75fbb6e3eeb18fa239e47d2c430032ca1db455ea0512750645"
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
