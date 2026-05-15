class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.32.7.tar.gz"
  sha256 "7a3fd6d8b3b1ff49645a82da1a83a6713afb1b631cf45bb2dab56eeb0c2dfaeb"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "359351d6d7bbef54208dec2927c040f6c694a3d021430bafb3aedcde528abf21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e985e0dcac9f8d5e1e3f08e191f2104908858c6a62071edf975e885cea924db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9c2ea344a15e126e2aad853ef3b0f075db90051f50708b3ea72562e2b988a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "397c02fe28c198df73e787337db66636a9472f2d667f43b062151112837aa0cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4f2510bfc6e2d755ec0f5a0750abb09860f582fa5c6e351e1f507b32781160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ec9764b51ef67287ba0df71b514192129ce8afdc2f5c0cfb2c231475a7b112"
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
