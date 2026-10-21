class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.9.tar.gz"
  sha256 "374cc8b5f9aab740b44b1b0d9689e69b0e6f2c0feb41942cb52d3e1c4bb7bdeb"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcd9bbf323ba646fc3040b9c74fee112daf1f3eb83af2f0aa288c8f1ec19b129"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f575305c3b8936fb07e967fe249b510e298794e278dc832ffff40c69f511898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9705be85a1226033fc1dce058f92ddbfe978acc23cec6bb84bda2dfef86ba79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71148be0a77c5e2193f409481f031f42e87aabda06242f3695cdc7534f781818"
    sha256 cellar: :any,                 x86_64_linux:      "598bf747be02c231031cc893a14ddeb1f62f89074cd8c9a5dbf4e0fa74c13cbe"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
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

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
