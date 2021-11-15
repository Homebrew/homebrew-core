class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.1.tar.gz"
  sha256 "a26c22941b406b8c42e55091c23798301181df74063aaaf0f678acffc66d8c27"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adf92c6ba8441b7b15d4dc75b5389b87cb58f044e93243e83e0a05c12f06e6a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d69411671074fa438ac319d5a96d9102eeab863f3eb8896c0545dd0c52865343"
    sha256 cellar: :any_skip_relocation, monterey:       "f8430839ef3e3cb4a06d749c6748485ff1fdec72c30d58d659d0847295526498"
    sha256 cellar: :any_skip_relocation, big_sur:        "f97cd12fbc692fe99b1f52fc10fe82d1df66ddd28694c3ff9d40357e079c0694"
    sha256 cellar: :any_skip_relocation, catalina:       "ba4c5c9dca9503ee60789ec5b614cad50bed09968741be0912be4af1145ff35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e96809c314e0acc641ff71690fbf7474884956e80dd42401976a0e005c86b5a"
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
