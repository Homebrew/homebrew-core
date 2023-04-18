class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.0.tar.gz"
  sha256 "b54c4b11c935f267a80693a97a6037ae7fb5cd2a25f30fed17d994d134a1ea3b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d585638b8756312f2681775c4857f182bcea7e9f0c09cf704579c22cb0af996"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d585638b8756312f2681775c4857f182bcea7e9f0c09cf704579c22cb0af996"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8a7436ebc5478dc122ac2894c25c1f0415d00dc30e21850629cba8da9a595cf"
    sha256 cellar: :any_skip_relocation, ventura:        "a0de621794ac92cfe76d09ed75b3a01d12cea0b1d704038331904eec307d3c43"
    sha256 cellar: :any_skip_relocation, monterey:       "856bf99def01e0583d90d817ab1a79b8f5b7db34051328592d85b6b0f6d90659"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0de621794ac92cfe76d09ed75b3a01d12cea0b1d704038331904eec307d3c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8440af33264e6f712443bf308069035d6f34aac11f910057917c1834e775d778"
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
