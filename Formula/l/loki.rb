class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "d3642bb140dbaf766069a587ae6b966576304dfdda3a932bf6e9a79fc8146b17"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2cff2abed447774de4fafab7c324154f5a6f601d6fd6fe254c4622df70a5eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b990b5623c32f2cd98e688edf1420b6aae0cc0b8289b087f39065c252db6c97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "724c8dcfabf94860fdb9233f9a0f034e0ea931eb994dce47a89d2be1862a973b"
    sha256 cellar: :any_skip_relocation, sonoma:         "53846c0b52d69bed844bb18ce2e5d9133686e717e2be1241f4861d3fd2617763"
    sha256 cellar: :any_skip_relocation, ventura:        "26e22b74f42eedd71408d8bd32ea89c82dc10ad47f1ce8697fecd6e7f42ce8af"
    sha256 cellar: :any_skip_relocation, monterey:       "ce798d982e32c008f25c08a962cb6309d2ee8c2defe371d32d235b2282278180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b6494f9543dac3763bcdf05a3ce372c9e3b698ac561d8b39fb4b65d14d42f0"
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
