class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "480994460326bf3a3723713e7385d8f02b16f00f7fc1db8ee374f7ffe496e6ba"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14286caea90a877c145a22d3a74d01ed7055bdef2ec4b19c8f9ec972ab10ba01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c4f916c13a8a40579dc30c93087e30884ffefbb2127b73f42e4a0f6595edaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bda02a7e771f2efd2078cb28ddaa412d05c8476094d8bfc8e40c5ac8a7eed19"
    sha256 cellar: :any_skip_relocation, sonoma:        "b982bec44ed1abbf170ebf76f31b445ab4af3266ab752930a55be363d50306f6"
    sha256 cellar: :any_skip_relocation, ventura:       "0843a405103264d93660ac576baad58cdab3fe9a4e41570d9e2291e79d037519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d037e5eb44c6d28e50724e3a6a2ba902c53328ddefda689b19e71ae7613cee"
  end

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

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
