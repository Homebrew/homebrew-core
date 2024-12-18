class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "dd2e80ee40b981aaa414f528a76ab218931e5a53d50540e8fb9659f9e2446f43"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e38bd4783e232f154f209785d2ed56ffe66fc62e01c754d84a3e1ffe7011889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f724b136938eb40625ddadb50d222e446e482b984018dc2a1460963f6de18b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4177da006afdb93f8495f6f02b0ad6fdbd8d0a234e2b3e9f46a8caa39a9a4504"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4193460e1997a9920244f9d730ff6a957dec1f6a476491c1ed495c68d6c7aa"
    sha256 cellar: :any_skip_relocation, ventura:       "dda4bd9911d9943fc9f977065b570d8bf01a199ffa63922c6faaf07b7f5f9a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6f7d97ec981fe873d1a1dabcad27493f2d4c082535a6b5039ad50e36dc8af5"
  end

  depends_on "go" => :build

  # Fix to yaml: unmarshal errors
  # Issue ref: https://github.com/grafana/loki/issues/15039, upstream pr ref, https://github.com/grafana/loki/pull/15059
  patch do
    url "https://github.com/grafana/loki/commit/5c8542036609f157fee45da7efafbba72308e829.patch?full_index=1"
    sha256 "733203854fa0dd828b74e291a72945a511a20b68954964ad56c815f118fc68d6"
  end

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
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
