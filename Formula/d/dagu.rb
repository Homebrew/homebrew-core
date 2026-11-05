class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.6.tar.gz"
  sha256 "67aae776a57cb04a762f1497a6a64d6e27d47f7ac2623b1693ddc312988a3588"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e25f7afe7e1555b619e2e1dbd3bc7eb5f35833dd763560538c6bd4f4b677e544"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c8bea5819884c687069f53e5ee178bdc61ec6cf8c2e0d97082344879784371b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9efa69e8cd1b4b0d0b7be22e3752a934dd9dc19dcf52e14f7d968f1bf60d5ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "64fea0a74bd39404aa26e1cce3550482fce49618e4d23cc6edd187d30ab2bc8b"
    sha256 cellar: :any,                 x86_64_linux:      "ccaf2a803fcb18c5f4e748dd1c34d7a58b4e69cae28a0263c0969a121e2c1535"
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
