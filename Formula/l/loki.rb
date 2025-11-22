class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "92fb716bf68a7e6ab6cd65b75929f3a32c10344a2426a8b113a3b0d195020a28"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb25d482d3e9f306976889658a381abd4663b3853652fbb2164b360adc572a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84069cb303119ccd2785176ef6be45b42de3def0ff41aceb6eba9c33b6c6d3bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c939d9b4e7e24742c44fc2aa04c181b266aba5f6eddbfdcf15738c183efecc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f9beb95e41a07d88a8b9052e9b20768ac880119252a8dc9d4f1f8098526f54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7702f95bf25c433ac036fe85478083c4d57b05fc932111f382bf5dbdde51417b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4d9fabb1ba9d51242b5e77d7b3beecef9e390313a4202f23eb785df631d30c7"
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
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
