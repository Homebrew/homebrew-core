class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "aa1f321ed176f2d236268054f84449a5e414e323c7a01e1591385f7b07f51071"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91015371e9e1127d647c43aa8a50ff05aa04bc842acf6e5db761e701b2df4598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91015371e9e1127d647c43aa8a50ff05aa04bc842acf6e5db761e701b2df4598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91015371e9e1127d647c43aa8a50ff05aa04bc842acf6e5db761e701b2df4598"
    sha256 cellar: :any_skip_relocation, sonoma:        "2101ea161a6f717f3ab3339b10cc555e4a212406f3d4acd0b790144b5d146136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4fd8cbfe6184c7b92ef8de542c0963c8e0cb6fbc25143b7935870be1d7b6b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f147e88f7b174d203eea1c9d373347d02c43daa8ad33cc28ad7d4ec310998df0"
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
