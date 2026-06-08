class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.32.8.tar.gz"
  sha256 "68201d9a20c751cf1fe60582af21f642cb8b8aefaddf031750c541e97889b019"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "832f02d603086bc86491181e7c9b10a6df44277febd50380ef5cb0aebd428697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c481807b7e6bcfbb0348a90074dce40a9982f35c35d7eb8db727fa927fa2e721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c2461f42d0fd60157c83dabdebb42d1b63f939596d6c6a692d7cd59ad64ea63"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f50758d0aa2b9178b40370c98ad075111dff88ee17caa95410faa447ffa9309"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9573c2e269687b0248bcebfc607541b1b35498ee2ba2f462ef1c05e9553a6457"
    sha256 cellar: :any,                 x86_64_linux:  "c113909e8075b4f982049d96322355c233dd85f33cbbad6bdaf91cc0417961c8"
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
