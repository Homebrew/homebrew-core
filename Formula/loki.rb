class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.1.tar.gz"
  sha256 "a26c22941b406b8c42e55091c23798301181df74063aaaf0f678acffc66d8c27"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc975249c00e03b4258f5dfd0d067eb2066cc32ec2830a3158635b7fae5dbfa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efc36d3d6665a195b681e8d29fa3dafe7193d21fd61c7fbf6fdc8e4208a961f6"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ad74bd07947ff1b1d3b8c550390ab19d4049b880203d8061d0f41e8ed3615e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b7d06f6e7b4a753930736044596570a9e94d037fe4d236845692b8540b54415"
    sha256 cellar: :any_skip_relocation, catalina:       "978d27f479b53c15e38f2c9819afc8f5f75a5ccc20f362203ec0a3f66972a2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670aac9cb89cf42f37c561ea88a47e21cbb5cb0f3bc9a77997ababc2924460d2"
  end

  depends_on "go" => :build

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
