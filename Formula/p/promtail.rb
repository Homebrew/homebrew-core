class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "92fb716bf68a7e6ab6cd65b75929f3a32c10344a2426a8b113a3b0d195020a28"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70b6523aa07b65fb726652a9bfadc3a7a3a01f8c13776d73330298d3d1323f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7dd58fbac4af1db148684f47f0e471d0fa71742568532d28d39d562be5dcd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d449f19de5d6f1215ab2bc32ecff81162952dfb5f06d53b28c55bcda8723274"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab10e11678fe652ed4265c2f8a4f9e1e040ce230c26eabc546e10e2ab773629b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77c50a44af1f5e665d7eca0acf4cb46e3b5287c6a141f43490cc5791c861d158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc126ead7268ab60415b401aa31a8f8874120f1e2de208fd5d14fa8900dc2f0"
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
