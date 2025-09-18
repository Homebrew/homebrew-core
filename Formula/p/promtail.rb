class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "caae437c5add69761a3772c51b4bd32a5d5f03440fdf16966ab27c7036eb2701"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67b7a91f9c94a4a95b5b7e57da831f7ca4f589247b3d134875466a89c7e05459"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c8a32ab57f058a8650e096d11f23faed7eb1544469287002ac15a68e8682bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9f5db0139a284319cd080c09411b1cdb0e6c153f7d6a44143a4c77e11bb542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "accb8388d640cae6b73f6cc171cc27e8cd196cd1d2bfab77d4397862c3c1ae3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac0b03c86d1318d1ee3fe2ea89475a170d965f1a61a89dc6271351cc6f9f3dd7"
    sha256 cellar: :any_skip_relocation, ventura:       "8098b0181225164a834762cf1a04adbb4e07f2bb7036fc8dc72d830d18ee2fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30314d7ca54292164f5b3127eda28b541f7fc01047626fbdb8f751b03c30268a"
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
