class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "fb5115c6ac65485bf8e865b53ffcfc0b0d86b9499487357c35cc2e8770fa16f5"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1d5fd6e41b82a275fd33ba7af5f67f956b81aea6963d5332717fe7a1b86487c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb490b69d399c0f8e404983cbd7001da8ac872c94ca9b548a4e193559b6d71f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a78e503ccc5a7a80cb92e47440f7d99239a47d44b65365da189c9fc6cb4a653"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5452cd035e701065daa44d7ed21ccb8e8187d60417880820b3f6825f38153aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc102d33fe5f0bd92dcdbf240fb53f55a34eae9ca6d2abe242cb3723aef0d44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c69880ab4dafbf511dd60a7c590cf1d4b907b533cf291f0975d7abd475e55d"
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
