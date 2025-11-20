class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "8400dd140b0966ce952d79fdd6ea8372d5d6971ff651fbf8b7e6cbb751b0397c"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b15d1a7d809a50282247c0836d67c2d2118b5dea716dd9d34bd2e5642be657e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b15d1a7d809a50282247c0836d67c2d2118b5dea716dd9d34bd2e5642be657e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b15d1a7d809a50282247c0836d67c2d2118b5dea716dd9d34bd2e5642be657e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb89976df3c6e90974e539af61a150b88505530524131b076f02d67fda0f9b3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5734fbd03ded1f0c28b9d7fd65ad93bde141c20f4a221d0540e198a86cf02696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f520c292e5911386213f4c05b60a1dcf0838c4c67fba4eaae6666010729b945"
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
      assert_match "Error: failed to start docker-compose", File.read("test.log")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_match "Please run 'install' command first", shell_output("#{bin}/kagent 2>&1")
    assert_match "helm not found in PATH.", shell_output("#{bin}/kagent install 2>&1")
  end
end
