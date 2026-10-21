class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "c670b7fcc84154fd860eb94889b4a535918c3a3ecc1924b86fc7ecadb7a5cdba"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3b37e03e3a11b86a0232988d9461c17e1510d97311c463e8a57139084e5db2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0d785eede985da73dfbc23068811e9aaac445b64959abdb983a99d61a58f58f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f8d20e0f4c859aaccd8ffe7f5a8dc992bbd621c44eeb35034448214be4cdc3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cbdb0a0f48f119e13e002cbe3e69740a60f9d08bdc9877f04c7a19e378283c6d"
    sha256 cellar: :any,                 x86_64_linux:      "71dfb46c3824fb8d9115a9d398a45488d856855f136b17df8defa1926e2e24ba"
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
