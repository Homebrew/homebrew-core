class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.25.1.tar.gz"
  sha256 "aa07e9e91985d8047fe177969b5da489b2b9770c3214e98bc970c4000df487fc"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c6b7cbd044c5841e7e96fba975e952236d2e90f11084e4b97c88af55e891b46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eba72d084785199f07addb79e0dc1f81b7d91f833872eaedfd04d67f3e4ca218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fadf92b93a073d771c29f8991a6c8547b6d09ccb6e1a41581423da0f1df6282"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a29140a7fb3c3f7c0a624554dfc00d2c707551ae0aff1ad7c3b6cfa0bc47259"
    sha256 cellar: :any,                 x86_64_linux:      "7e5fb212e11eb9a00ae7937f7c9d2601775641a29bd26e51672789466f7ad526"
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
