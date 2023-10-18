class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.2.tar.gz"
  sha256 "9c1a153ab4d57d5c109dbf55d4ea5aeab2159ccf51d3b8cc8fea19970f0a88d8"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9de0e1d71c8967716bf7f9486744b6bafb68833f19e3ffdcd16714fc401ed1ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e4f54de4df30be6835ec12f2054bd1207e6d57f4c9ea55e26e041ccb1a8ac9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7dceb432217bb026c0b88389c0aaa5098d099a8d7d27e7d42ecb193521592e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f57de6ba189c47adb642ba820c6fc2495eaf500246bf7f55fe38a5500ecc256"
    sha256 cellar: :any_skip_relocation, ventura:        "64af9f7a189ccd91c2442a1e26075c764f153dd39ae0ffbee0490247af6a112f"
    sha256 cellar: :any_skip_relocation, monterey:       "031a22d4a78dee4992adbd801171c4704df673751ef94e297ab339196a8ec907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29be5e95e11dc8baff03efee56e7f14b99bc959d19a017b96925771ab7a2b6b"
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
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
