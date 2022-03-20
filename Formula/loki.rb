class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.2.tar.gz"
  sha256 "725af867fa3bece6ccd46e0722eb68fe72462b15faa15c8ada609b5b2a476b07"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4af5ee5b90f62533016e9fa49b3dbb75c28d7311a8839ccde9e48b19915c738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "763cc7c32583b0fc6c7cedf2f28f848e10f419bf14e1113e1b42ecde6d856662"
    sha256 cellar: :any_skip_relocation, monterey:       "c3bbfd34c2d12e9b80cca286897cc724aba4ef32b331f4464864e3aa993263b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "befb86745a607d1bbb544933ab0291de3dd7a0beafc1e5e0d81a89d5b7c8ce76"
    sha256 cellar: :any_skip_relocation, catalina:       "a0988a2aedf5de68eeee1fe2313f4833438a964b37dc68708ed5ac25c11fde07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "384ab59b823643fc5ac574529d978f6744d1f755aa70d5fca1c420dcc45d83f6"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
