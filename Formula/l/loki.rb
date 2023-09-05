class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.4.tar.gz"
  sha256 "d594cb86866e2edeeeb6b962c4da3d1052ad9f586b666947eb381a9402338802"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "362eadf9df9d124ff17378a87934f1e7cfbae291933b215dae0ec3e76a32a9d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "362eadf9df9d124ff17378a87934f1e7cfbae291933b215dae0ec3e76a32a9d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "362eadf9df9d124ff17378a87934f1e7cfbae291933b215dae0ec3e76a32a9d5"
    sha256 cellar: :any_skip_relocation, ventura:        "91c1b00a35ccf07460418bfad505a5ff7e32a0e7ee124bed9a40038c7d0265e0"
    sha256 cellar: :any_skip_relocation, monterey:       "91c1b00a35ccf07460418bfad505a5ff7e32a0e7ee124bed9a40038c7d0265e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "91c1b00a35ccf07460418bfad505a5ff7e32a0e7ee124bed9a40038c7d0265e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9cb88d1dfd2ccd31a2a0b54182cc832746d578ed0f9476e2da12f59f441781"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
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
