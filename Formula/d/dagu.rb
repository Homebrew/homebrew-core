class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "496fe8c2f7008ed3a692c8fc2cad88e7114029b5b7ba7b0779e307c00f6c2be8"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21affceb3bfcb89ed9ef6e7b51589fb5a157de5b9f76ee3aa228a3d712de703a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "653020a41b113104fc0f53890f3cd7343fb30f3d8bc44c22e9958d50c01dccd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a8801412bdaf1fc4590ae833f1ece958b45b24078b094101086a48aa161443c"
    sha256 cellar: :any_skip_relocation, sonoma:        "417eca3e0105a083b2d703cb599b6f5e43519296bbc9edb40922da91ff2b6c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c490d6ebcd4a33792b34bd996eb6d58708e8d1cae7c346f0707b4983efb4330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5048325455a048e6a5e5bfd8ff465e371a327b6b63fbeb11222cd9155e14083"
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
