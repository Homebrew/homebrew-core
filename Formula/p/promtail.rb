class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "d360561de7ac97d05a6fc1dc0ca73d93c11a86234783dfd9ae92033300caabd7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0ada994b52a5a36ed6f90688b8bd849b3ce4195de89854af7fe1ed02f3fafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "039a7e66ac63eb311880b6b3e1af3bd71c6973a2f0f150caa488abfe975c30bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8e5de4a9b5a26e692270b5a932f767d84bae2044e5eabd67c5f356c1c44c62c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee0a2186fb805c559658a002f3f7ebce55cb27495c7bfe8d29066e72650a72f6"
    sha256 cellar: :any_skip_relocation, ventura:       "9261c1880cd04c7710e656f44df23d131ed7a6c91da5f6ea519c5286a239ac2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb6e67ff07eb14ff8791762a4e6fd07735eb3b4e57741bb8902ffa5eb1d8cf5"
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
