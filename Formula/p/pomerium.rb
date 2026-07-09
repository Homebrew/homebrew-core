class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.32.9.tar.gz"
  sha256 "ca69ae564e584be021dd2af85b8ccda0f791842dff9488f1e463cb26916f1d7c"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a36c0e70c802bf7e598d12c783338ef41c411ce71574458d73f915cc2a8ae4fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30250e49bfe09c22294a8731496699dc669d6870c53a5d00f461a9786a6a58eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef778a9b3227b213406edd4143589e0ef0ea30040ede12a689b5b4aef8caac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "39215da8c9c3db1b847155a29d16844a20444e8403e4a348e63f31893c9bc838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4240ccd459019798d79772be5c02ebf3ff7d7c94df5033568b8592f2a2a63507"
    sha256 cellar: :any,                 x86_64_linux:  "e468cd072e1fc71e1c5135b322647989c88fca1886b1d43463386db5e59ad304"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "make", "get-envoy"
    system "make", "build-ui"

    ldflags = %W[
      -s -w
      -X github.com/pomerium/pomerium/internal/version.Version=#{version}
      -X github.com/pomerium/pomerium/internal/version.GitCommit=v#{version}
      -X github.com/pomerium/pomerium/internal/version.ProjectName=pomerium
      -X github.com/pomerium/pomerium/internal/version.ProjectURL=github.com/pomerium/pomerium
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/pomerium"
  end

  service do
    run [opt_bin/"pomerium", "--config", etc/"pomerium.yaml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/pomerium.log"
    error_log_path var/"log/pomerium.log"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      insecure_server: true
      address: "127.0.0.1:#{port}"
      routes:
        - from: http://127.0.0.1:#{port}
          allow_public_unauthenticated_access: true
          response:
            status: 200
            body: "plain text"
    YAML

    pid = spawn bin/"pomerium", "--config", testpath/"config.yaml"
    sleep 10
    assert_match "OK", shell_output("curl -s http://127.0.0.1:#{port}/healthz")
    assert_match "plain text", shell_output("curl -s http://127.0.0.1:#{port}")
    assert_match version.to_s, shell_output("#{bin}/pomerium --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
