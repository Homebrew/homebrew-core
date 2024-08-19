class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "d53a46e3ee51a258f49f865cc5795fe05ade1593237709417de0e1395b5a21cf"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4af6a1fee9fe664f8e1aab0913ac977a9d7dc62d3a6b583bb5480d95f28a136"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "657c01bd74044dff21c3c210809e0965a84e4024e4d841f1a9e78f6a76bd84e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efc2b1c68ad0ee994b142fb107d0f6d526c6e194526fe6e0bef5246bf5bfd353"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5f62f84a90d138339ebbeaae5a4c4806fb6d6b75691fb17c1efa18611a3c205"
    sha256 cellar: :any_skip_relocation, ventura:        "aa739b150b7bd189a16b49bf580dc0acb16308356d87b267d7cda7e353425c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "5faae058b798fa4698f49c0c59cc1156885f4f3212acd388367c31cede7e4bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea7a2ea7fcb0a96fdec1f464fa230cca5efb55eacaa958ed2d9a735a9aecc7b"
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
