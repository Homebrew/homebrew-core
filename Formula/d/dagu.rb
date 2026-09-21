class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "874ebd49d950fcfcf7c033b86ebddd81a7f724502702f32d2a4a985bfc960f62"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7387b9da15af13252d5db854da3d2632ac61c9c8268277504a9a4f9c29260cbc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ec293722e95e283d109988ef345ad7fd9daad3f7aff5049dee9b3e8a688cfa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "977dd059b62907dcfa1578070d8da247846223b085604ae98d79b14737ec195c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b016cd1b4da7707e5308fcf9cd62ce927f32033ab27a0f0dd34c9e8d4d00fec3"
    sha256 cellar: :any,                 x86_64_linux:      "95583299d568611645e8e434404486a376699acf2d23235045008df30a1730c9"
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
