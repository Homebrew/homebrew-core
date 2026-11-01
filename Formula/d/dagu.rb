class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "b0fb8121f28bb98b3f1485d2d8b1922674ea067507b7f2d392c8dad7344820b1"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "266805f91681d781a1e517e340be716eba488a8f779c8b823a56e3e49de9d725"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "804ac3dff2a8ad9a56022859550a5f109995e495faaaec32bd02d03df5ab86cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39f19524a10dff5e6916a06161126cec55da5ee88a7fa5334f9f7db5187cbcbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "201b59576dce36f1ba6a37839e526062e721954f2a4f79e793221893d6a1f6cf"
    sha256 cellar: :any,                 x86_64_linux:      "cee83165bda25729ca81795dc57deb5729594cbee7ddc0057437ee42e71791ad"
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
