class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "05c5d23eff751b9c4f4e49918359e35b7ba840a5b504e3eac0befe4ad94ad464"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a74a587ac2ad98fab5c9f2798153e921fa6b2fac6d7f6ab577160a9f76baaf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a15c057482a418fe5f1c6a6f396f6f41badbdd92e75b6f299c9476eb7bee9b3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c0faf97cabfa8ff7a4f3800bd0ea62046c7c2c888b91a798620d698a522a53d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e012b34304d8e2ba3d59b3f152b0d02c268edb5a6d4dd74afed37305988eb019"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb9dcd94e00bb629e7e44a1c7549c578e785fff136c52e32eccf3bdfcd4fc2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d0320e85e8108f455108d5b108769177e3f277ad7896d73e8765d4a56be555"
  end

  # Promtail is deprecated/eol and upstream removed code: https://github.com/grafana/loki/pull/21245
  deprecate! date: "2026-03-02", because: :repo_removed
  disable! date: "2026-03-02", because: :repo_removed

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    spawn bin/"promtail", "-config.file=promtail-local-config.yaml"
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
