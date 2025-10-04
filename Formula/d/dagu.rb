class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.9.tar.gz"
  sha256 "d67fc8146ff978f3fc1bf7789b14f74f630715d4850f81f777c0869dd187b4a4"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03c50055b0ae97387dd3ec8a698cf98e27afeef59de6783106782609eb8e1048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2ab270539638d5cf1dd2e7134971a1c9c4dcf226bc4db697cce1c618df6297f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e5ca99d323a224ac77dc97cd39c506113250b97cffc6f5c2f09d1993b4e24d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef4b5f4b6431cb55b35835879607b5cd4676f93134e1bf887cc0baca5b8f72e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8dfb48128ac41009cafeb103cc31e0d121e4c35081c90f99d00ce995d49a8a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
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
    assert_match "The DAG completed successfully", shell_output
  end
end
