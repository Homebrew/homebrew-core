class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "f08b083f3ff7351560b4f86b0cf7f94fa606a01c9894d9baa9768570aba7508f"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1ec2f89d9f23b50ec12aa89c84562478ce78c94aa1679a0300f84c0daec4b53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3158f869d3e31f2bea7a6f1e985e3e55cf3e1584185a9a905f9351dcddd40f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64bf88dc8b15b7787c9a5041618c14884ef118cc5b554ea9265f9c0ae5e7dd87"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9e7fc9db0ce67f3a620085d1aebc2ac14ddc9ace28faae0dbeffeef7c3bb480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeeb2cfd7f866a754931c2cc38737960dd258acec79f1cb5eba65ee84d2615f0"
    sha256 cellar: :any,                 x86_64_linux:  "4f041ef7179370a6c5dcd66083cd0e57d1183dcc3f1c89d47000f155572dc111"
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
