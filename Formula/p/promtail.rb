class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "d669f543b7f5e9fdbd3aef94cc8f02f618617c88125398496d99b9c162ef7f7b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8320ff44fadaa4ce7a653692f84cb20f9c4b9632a68c93a8b9c097e2765e4abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d87ed87e148f15ba58b3d86713b2d0c85130411942b6beab016fdb9ab65a1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a99cf7e3f400fa153c4dbcbaf3077f05a1df626cee192caf531cd8547ad41cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ac583bf847a39a6e100ecbb74c2ee08d772ab09c6e2e8f082fa8a5dc7347d44"
    sha256 cellar: :any_skip_relocation, ventura:       "dbf485caf269fc326fb58c18cf145bde9751556e74d90af8dac1d024994b5f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dc8b2015eaa1be9d7e3cc0b23fc61f14aaaf2eacda6df43e2cb045c1b379ecd"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f49c120b0918dd76de81af961a1041a29d080ff0/loki/loki-3.5.1-purego.patch"
    sha256 "fbbbaea8e2069ef0a8fc721f592c48bb50f1224d7eff94afe87dfb184692a9b4"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
