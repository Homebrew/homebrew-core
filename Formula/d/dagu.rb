class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "e67e2f64462d41019f2195e14e8068c5776d38dc718272be7b1003c4dbccc918"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e8c27b080695c594193cd5075e22298a7cee09e6c718d65a89ff8a37400cbe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f21b2cfb924d42495590bb40df4a3eb48d3b60a5d0e652b840209f1793248c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e737fb994feaa00b2e716920dfd7be2d87762f93847f2b454a3e5ae0c6b6622"
    sha256 cellar: :any_skip_relocation, sonoma:        "711cf75163b178ce9d3bb2d6819a1f0e45cf10a78dfe8edd1e3f57694ccf3e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cd170e8f2656c2072f06c64446689417fcaf622fc3dd6ee6855e12884629da3"
    sha256 cellar: :any,                 x86_64_linux:  "16d0534667c511fa499f74c03d368cdf7d9082cbd0051b4a032557c8a29c11ba"
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
