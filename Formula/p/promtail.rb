class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ef44e222086dc2e580394c2a1148f7c0bc5c943066a0d18498f2bf6e64ef5a1b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d48a4a2a35ddafad1c0390b569e0d5467d11222244c87778ee76a102a7ced887"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96c1c80e082150cd9a51701339ac2b031c93c89a27e59600954bcffc7b6fb073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "779f7e5161b402bd977d5e3a961eb2ab488c409c5bc673f02a3ba7f2837cc997"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0c447c630cf1d1d2a5d9e712f2ca8996b4a4fd4096ec8e725ffe9951b2be50a"
    sha256 cellar: :any_skip_relocation, ventura:        "59778d6373729a599edbba953a02523b4de68aea0e66242888754e34e006798a"
    sha256 cellar: :any_skip_relocation, monterey:       "c7edb6ff73e6f142ee453e65a8eee1ec8744bc5ad0ece4a0f4177198934a14fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee7a3a092591653633f524370d449f17dc6fe9f646882dc45a3ceb78d91f544f"
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
