class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.0.tar.gz"
  sha256 "38e8403e59218cfa81b38af48852e77f6b6be5390190b99bdc0dc157a7e0400b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47218a12530e06bb4a3e4d536cc346d21147a695184aebba50fed4d965c23d1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29e269c258de9b5e0f3024db55c8cca0023a372a3f4372adbb82f6d83fc37af1"
    sha256 cellar: :any_skip_relocation, monterey:       "8f5b60ca6389cb2de6ffec269e2d8800050569ceba9b98eb3f781ff093582a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c9c206eaaedb9a6d40f0d0cba0d21118ea3f35bd592b6cfc8d7f7d2862ba49b"
    sha256 cellar: :any_skip_relocation, catalina:       "e10eda7df50a4f13858e76389bc2d3bf62b86f35926a254266fbb618471ddc08"
    sha256 cellar: :any_skip_relocation, mojave:         "06307778ef44db3b181461e0f42c31a95796162af5c774c7a0248848e6005fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8476435961971f582f3baaf20852c6ea87c4129fd06f25fb13a613443a207153"
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
