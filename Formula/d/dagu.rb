class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "0f5a35ac86dd5214040bf572648be9db8a44b1f20afcea6853fd34a08523786c"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92b5ddb63b29a813a3953b8eada744f02740f036bac374b955aec3b9762cf85a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dce30bf9f14c462a5904ea640c9937f0fce62f36d2ea817cfc54cd6010b0bf30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b21bbebe13040ad33933bd795180ffaba16d8b289acd7a5dea84f1dc2436ef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77c982803c637c17d3a497a8ddad80a95566a8ea8b63bcd54b4df04fb6b3f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc46a8355328b8387ff3f94617f1ac1660ef1f5d142fcabdb07db6bf8989926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c934ad02e36dad27b87d5da00460fe388571438ff589a95874cf2b62e06c5b4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
