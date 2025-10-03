class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.cloud"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v1.22.8.tar.gz"
  sha256 "e5aa1c4115d27dcd3ded0af35b27202be9c0aa42a5d7e6b2a5735f709caabcd1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f78d6a2d3f8ad41db8ad7b33bc01d1f2499ba038325024dbb3b8ad12640f6cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ab6d0e97f1c10ac3cd6797cbda81473f20463a4fdc98d77b675bd293e78e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d891c884f13eeeda1957265458db8b01e6c3c6a129ff0a34541c3a5f3eee8dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bf0142800469cc0fe3f995a8b64352643c3bdbe51b857e2775bbabfe47b92fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e44354619b7c206355edced8f5d70816810ed769edef1b0bd896195f097c8cfa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=#{version}]
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
