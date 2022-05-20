class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f9ca9e52f4d9125cc31f9a593aba6a46ed6464c9cd99b2be4e35192a0ab4a76e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9125b93bbb9809b8bf7d88d531257eb6350a94a1576402f0f6c3a26bd5a0683a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8023a2d258b0f3fca8e56fdd3e08a1a9380664b83d3c0e60c239aaefd69dda2e"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe64c942781fd6b7ab51815163977d4753479ac6f48bf65fa36f375700d7da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6afce547b2a0ca7913fe79b417d5d4276b78bc88aae24c352bfdfbadef9b9977"
    sha256 cellar: :any_skip_relocation, catalina:       "d50e5ed91123ba88660a847b582ffb9bb72166fc0869e85d88cdde1142c2e4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5d4efa0852c44b33278bb6eee967dacf8b7c48a32908452a815da1c91cf8e0"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
