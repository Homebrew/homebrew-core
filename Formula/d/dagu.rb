class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "a9e32974d33991c6aabce0184367bcac43226a37b80927e3d793d5c73b2a7360"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d35bd381cd4d49cd26c1869d49ee301b502a96e798312a3f2a5bdb49ecd03af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5433495de046b3990d0156d7c9db18bbf805e93693c593a6ee4b79731f6d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d38a9fb2fce06c9e5b040e191a265b103e05973a5eef10c60b35f6eb0d24025"
    sha256 cellar: :any_skip_relocation, sonoma:        "c67297a19b3cf1015ac314483db020b6ae6e201a3ebbb8ad3b1f8000c2b18cce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c83a0167ff720b4ccb9947e864fe1b13db2dab81e0ac9e1987cae2aa1fedfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1848fd1d0b5f63aedf616f00b2815e38e40033b27bbbc1ca783e1b35ea2f8c1a"
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
