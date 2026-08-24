class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "1a4f6792005a2f9119ef7c749391c9e9d5292e5ba4ff3eec7d92f7a6c061937e"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400495e9d8c0235f008933e07ebe27f8f94dc74e6398630b4ad9bb265a6353d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9b5b0d4cf6ccee7a6fbc2343215d3c735be598e21711e78a53f73cc1f309d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f252f7fd4c3be241fdf9bea06b05a6d45119bb634b784d848f7a3b07bfc92fed"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91b557e9aa7ba1d84c1e79ddc2586a04593f916cefba69742a17f3682856972"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "481f99da5895e48c6c61419b953c2761520b6268e7cd2a60325fb163a0b645ad"
    sha256 cellar: :any,                 x86_64_linux:  "dd33c0745856a7be765fe629f3a6ae52c9d7992e955c463aaae7a261deea31cb"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
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
