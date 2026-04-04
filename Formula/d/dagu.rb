class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "980da5fdf1f36ca7d7cf255e27e7da16f92d841887a617c6b8e0e6b306479282"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce8305e6f68a5a189446144e0897ab723a12f9bcdef22d3f1bd726fab9a12393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85e2a3e9906ace91705108eab0f4becd5474ab73b366550dc76a40c27f639675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052ca47c7ae84bb4089d2b1aa72c84cf2de579fed2f78c16d2847f71395a6b21"
    sha256 cellar: :any_skip_relocation, sonoma:        "69bc027955ded9b8bfbeb557dca77507f595428fa3a17de31b6902b7b5459988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d51f43c6e5989a62bd19fb876c9f032b363b0c80a67e6f90bbf44acdfa2caa99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e5bd88b258ab22f35506e6a64752900c9a4edcfb803b3cbabf90687c86cc4f5"
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
