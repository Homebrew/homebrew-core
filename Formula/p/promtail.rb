class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "6ebcd323959fcc6b6ec5a466c5a6c975d186c9c3a81b61f3c69cdc8b047c1961"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20602ca819e7a52281886c5a751759c5dbc8caf82577a0e23d2debc101f098ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1991630c6b990da2af196aec20796b79c65f6c8c8658677cb794fa69af97909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "271c50b1bfaa8207809606a2d930215bafd93090bd11162c6af24ca5c4408cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7478272711dd38b33a4e1becbfe7d7830fd386d83a38eccbe0348a3caaffdb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de70cfbbb2c2ec874dc6785727a2a36c917f539f95a1ac39720f16a8cfb36995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad2cd556056ee6b4bdc133199b0c053a7df93d00e79ceea3ffd6c3e1c1a33bd3"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
