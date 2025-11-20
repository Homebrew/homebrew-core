class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "0be8473755ad90877f2e0b6ba807ff40d5ddd952dae653b967bff32dc58dd4e7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82235af2ed72d9d79fdc4d7e7bdcb3ba03e55013cda7479fc49ef8816d096d2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4560f83b4759977b9426e22262d350769b2dfe1e4abd352a3d7ec9077ee1a2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1db5f84d678bd6b5a62fa761c8f4d8818aca03bb47ee99453f46c94780e099c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f00be3cf26f4cb7559416ba1568eb64e3d5650c1f0eebf6a6c3f96a8a9bf8318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e569f54e2db68ad1917d9aa06afb29aa9e598cba0bfda54a16026e31374130d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad970972e1130884205419d15e749b7c757a0732693359257285f3e9c1a1a27f"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
