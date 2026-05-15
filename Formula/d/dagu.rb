class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.10.tar.gz"
  sha256 "afaf9e98f46e14621804dd59015736c5a51fc20d6204a61d80a9f0d33a768875"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e70eead17d46fd9456f2d7e22297e1449eaadd2661d1e3489fb7d62bcfbf0de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "800772a271c13f302b4d2264eff168a2e50dc4ce251aa9d3e1a065270995c806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9936fab3c0f44a6fdc84747de3e7e75713da024596b6f9cd0bb34939bffedb68"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcd2f945b165a0a940baa90487b25399483a3590bf946963d73808347ce0e6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011d8bc2ffd0b2f3381084111c66e7204be2d6036600f4d048a93a023074cd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "542e0b95978ff7468549977d0064dc87a54380c546ba51c9398a78e581501f96"
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
