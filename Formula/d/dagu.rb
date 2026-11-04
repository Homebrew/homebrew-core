class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.4.tar.gz"
  sha256 "13720fb696a2ca70857e21d52bde6a780ae5abc7b3962702740ad80939341e6a"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b9c5f1c5f0731129cb2331f49e64a34afc07d657b9488afabf056929c55dc85"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "744cc681b68009350568661aefa7b41437ed5ffe5cca0a40acbeda111504e8ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "822332e29a2d2b3e9d6ce571ce072fabef9d91c9cb373c18d98c48292ffb431e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6c400881b4081bc38ff11c0d7ede1f5918d0d53475a61c1ed2b587d5f6f8fc8"
    sha256 cellar: :any,                 x86_64_linux:      "b4c683dd2fb5cef390535582c7aea280928c8e3e4256e34c3a1ebfb7069a495b"
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
