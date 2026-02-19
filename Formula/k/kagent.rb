class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "1057f7a7c00f495c4e6683efd59bd71687d221855f0aaa64d76f0fe9b2cf1697"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb736ce526385c8fdbfa3524086dd8adc4f63332ec23a1cc69c829d388d4a370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb736ce526385c8fdbfa3524086dd8adc4f63332ec23a1cc69c829d388d4a370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb736ce526385c8fdbfa3524086dd8adc4f63332ec23a1cc69c829d388d4a370"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff2d3037d1ad6e9ab94b4a3f91ef6982173b280d4ecb7fd94bba0c5a63bc29fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1008f60169eda81f77ec649fa147e585a80bb32177f9df1967f0e73545af1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6874798d5b39a4710f07b881f2dfe8af05b982d116dee748e24e5b3cbaf8ca8"
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
