class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.0.tar.gz"
  sha256 "b54c4b11c935f267a80693a97a6037ae7fb5cd2a25f30fed17d994d134a1ea3b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec840b293cf9717ec48d6d68e42fe1f91d8b0b92732349d141c500182d1a5d21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec840b293cf9717ec48d6d68e42fe1f91d8b0b92732349d141c500182d1a5d21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec840b293cf9717ec48d6d68e42fe1f91d8b0b92732349d141c500182d1a5d21"
    sha256 cellar: :any_skip_relocation, ventura:        "78049098ed4a564070dec91c304ac8bc6ac4d22fa4a457587961c351858eeb98"
    sha256 cellar: :any_skip_relocation, monterey:       "78049098ed4a564070dec91c304ac8bc6ac4d22fa4a457587961c351858eeb98"
    sha256 cellar: :any_skip_relocation, big_sur:        "78049098ed4a564070dec91c304ac8bc6ac4d22fa4a457587961c351858eeb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1234e2a3135fb984a10aa04abb65278131454848049032c34851b0c05bd034cc"
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
