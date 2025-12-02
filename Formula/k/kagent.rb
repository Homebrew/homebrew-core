class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "d1c5c5ed40bc46d0df15f0c1dd642c263bcc63fa58035134ee1ecc1621b750bb"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d814e75232e6441813e3f51f583146b199053449b6033487ea2d9cdb94ced3ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d814e75232e6441813e3f51f583146b199053449b6033487ea2d9cdb94ced3ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d814e75232e6441813e3f51f583146b199053449b6033487ea2d9cdb94ced3ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "c018487cae28e84e6bd1cc64da0f473cd600b7cc1acd5ff41512654e162ba7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29344eb93b160d7a5d57703723cc1579bf52f3bf6bc9de1f7aad167ab456e26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769a151bd80ebff90345f6b372e4ddc62e363d341c78de66df21dc5e11a8991f"
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

    generate_completions_from_executable(bin/"kagent", "completion")
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
