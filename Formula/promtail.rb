class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.4.tar.gz"
  sha256 "b5521c0d12699f59ddf48ff7eaacddaa56abe90da4579f35c18f0752fc8e95c0"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e9af057f5e372caeaa3cf80e6debe7252a7ebbf309551a747d40cd3cb7970f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69733a407c7e16462eef2ef65f1a9353404f19c556cbbe94917077dd5778460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46f23b21ca702192566d6eeed009afdb225da561593b8331af766918a29e4ea9"
    sha256 cellar: :any_skip_relocation, ventura:        "c699d6c2234b090722376da1e7de7fd8afcffa1d08a42c47274e38fc898fbeb9"
    sha256 cellar: :any_skip_relocation, monterey:       "68fc3ea98ca7a26bcb67942b0a46a3564bdd79d94f86f5bc3258b5bdcbcf2996"
    sha256 cellar: :any_skip_relocation, big_sur:        "76e0855d57e840463d7bb8e0b9d003763cc7c05611772d0bfc74c9ea410af402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d12eb4cfefaa68a6792b121c70241185e88e7d041a0e263c669057daa281f5"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build

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
