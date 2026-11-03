class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.2.tar.gz"
  sha256 "87c7e67cb136e34f57c8a2bdd5c730c852ed9b6aa7c7b99beeae0d8a6d299910"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f98533d30a9b1522a8e7f8f38060566be97cdd8aeb367a02695742cc09ef4b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43016f333dad2952de5c2fac2f6271c9587cca5ee980fa31478cafa0ed6bd46c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8aab2faa5382db0213cd37a81201278cd8ea2c5d8f0eabf8ac3db71d3a1f70d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5110751cc136d53bc1bdf82fc16f3bd52c0fe843a77b1f04be0d9ca7aead0049"
    sha256 cellar: :any,                 x86_64_linux:      "515ce9deaeadfe1414cc86c3e3ff0c612dd61821cf928ab521120bbb355db0d4"
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
