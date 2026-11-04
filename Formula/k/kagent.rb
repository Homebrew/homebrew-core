class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "396a13ff1eb03fe8093c2900617455124467742d9f3ca4fd19a87d589dd7411f"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "288f787e84b3b8740d4b89c5df1a0bd3ec27830df6212c04d28b55149d31c34f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13ad072942044b01193c49a4351336c0e5b3b9ff53978982ed51f4bca043a3c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25aab2beff722a54a12139a970aa9f643da8d2fff9cecfda1f37e45f27cb4a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0cc6b4ceb8b1353cb47c5b7719004b1f2eabb50ed61c5970075eff0a96e5452"
    sha256 cellar: :any,                 x86_64_linux:      "fe91cca3d737019dcf9a037a33811e94d9ab4be020243e5ea232310a58191892"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

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
