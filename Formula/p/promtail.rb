class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "c67f351ddc8eaa66bba5b3474d9891e9ef8de4bcd89e8a4fd0cfb413bca8fdc4"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdaf0b2daead2ac71c5b66281197309befe39474099fed166b387490d01543c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff561cbedc5d9a0bf08b389328e899c460cf22ab7095ea06576cf0cd7f60f949"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca199a842e16768f32c1ba76d07e32d439c48e5842dd5d6482c3fd34694774b"
    sha256 cellar: :any_skip_relocation, sonoma:         "77897d26808d4ea485f852feab2d7e9361f79edb00a0df5e1ab265240ff2653e"
    sha256 cellar: :any_skip_relocation, ventura:        "fecea2cd85a59f97e04f4582f87bb3261f3f3f113bb39031e0edbf6247e1bf47"
    sha256 cellar: :any_skip_relocation, monterey:       "e240143f1d8022571474ec2446207a4116e4e247a7684283204dbdbd534edbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b00beac14673abe9528a0e3cb54e507485622947d2f7b8132d2256526fec19a"
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
