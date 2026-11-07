class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "51b0a1bb32811a1409e082d016c9915d5fe1fe53102d4787534380e65b2a4792"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28ec7842184ebbc775952b8145ec490db1ec59b0668de55802d17d9f551eac34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55fb64d2739d8a15d8f4041192c619c2f8bb8237734a5a506084c0827c1ba627"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2879fe45574740713294e6b1954bfb32290bbdc829e9fecbe9f8e786e7c0ce3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ef7d5421aa1474e838d80cb8ef37a55b9d582c72826ad16196d9fa6336106b2"
    sha256 cellar: :any,                 x86_64_linux:      "7ad990f62e07616326ebd9e74b0dfac675ab96d01f74dfd4bc1d5c9fd2c5a0f6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "fetch", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
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
