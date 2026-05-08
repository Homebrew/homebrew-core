class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "8ea818a55cdb3fd7dfabf844669e59f4c764d1c502448b49bf0efd18c68febf6"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61d4277cc413674084ffbf65ba5eb66cc733a14687795fa8a567795d9dc2ec74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186a3b3a2135b142e8ef4cbaf1c900049b0ef8147109fe16e8b436fe1e863bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ab0d748f6749394f6860cc8ade935e65221657f2abbb07c4bc6c124d9d1626"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bc5e6bf2303843cb4a123907ca9bf7c55daf44c4649f2a110f61e5092b6bb9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f42d722163f49ebdaa3679d9a477ae70e8c0a9d39bbe6dfc65b04a07daea903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88208575ee8db2c0bff5f3f5a1d7d8c74288013b9a921f9cef2b3b8d0a90de08"
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
