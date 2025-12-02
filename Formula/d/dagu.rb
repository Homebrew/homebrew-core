class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.24.11.tar.gz"
  sha256 "b7845d702a7b7c630257270b13986ca71aed8d24734d2a62e6e12dfde89e1fce"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b35d02ce5dcc30c753ee3e83a83adfa735e30e764ea26ea6abfebda9f06f5515"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059a7d08195134910951a2b1ef1a82bc813ce30f12a5db5b07eedc95a8fc65b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87717b503f31a830be9f473d571fb497f90ee3f5b2b7e423f3f170827181d965"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ddc653789b3107a92561fdbe54342c9715f7852f55eb07e99e2c73bfb59fe30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0dc497aa065d983e3772ba0563018d6faa39dbd6a4dffcbece3252b11e4dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e71eab90d1b8c60f1c2ce797f2ff3c1f33bd6a7fc702d3121bf3a4fcdd42c6c4"
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
