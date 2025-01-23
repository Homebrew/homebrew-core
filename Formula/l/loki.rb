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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fd0beded217871d642e1f09eca8198cfff0e480b1851f1139fb2349e377d70b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9536ea8a854152b333305728480ed1af59bf5a3ba9fa7fc76f1f27fb06fcd971"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dfd2b5f0f0b314654dd9298f2403212ac4abdaaad87e1ec1858532a63cfd54e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1d8c5232fd60805acabf75955e860a781a40de47171f3cd439ef71af255617"
    sha256 cellar: :any_skip_relocation, ventura:       "685c61f7b828b0e6e37326001c10522533cc9d37341b6592cc44f3d0d23afeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04d00ca11fc0cf92bb0493bb4f965410ba887c18399d4f276bff76259764aa65"
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
