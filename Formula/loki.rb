class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.3.0.tar.gz"
  sha256 "c71174a2fbb7b6183cb84fc3a5e328cb4276a495c7c0be8ec53c377ec0363489"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "428bba8b394ff5df1d24f9cdc7442b0af94ce6744768d3155ef78e9917e54428"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f1d035a3048b1b7c6a8da97c402b46e14749cb2bbeed9da0a1b69165af04454"
    sha256 cellar: :any_skip_relocation, catalina:      "5ad6744fff9fc86d40bdfe9f8e8fbfd8c61a2dbb6b4dcb4e4fa84604fbf0d875"
    sha256 cellar: :any_skip_relocation, mojave:        "a74082f6653808f5b4d6180678223c8b2ddb9b8a288b31964ba3d8a17db2f25b"
  end

  depends_on "go" => :build

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
