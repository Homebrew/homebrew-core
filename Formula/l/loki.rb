class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "1f74768fc476978796b49455fd962587a6b0e3b75212215ed8449f792aa5c776"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5386867442040cb7ea14cf99c03c131d4d429a2029710c6f4e79863da422c817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d8261319eb20150f8e365ddfa75362fab3ef93c420b0a066ea0f35466a8929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a925cc1ed763a65b774729b89f3a21a3145c3969ea85c76ab0a414ccc32daaf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd699f4630261047051ae94fd7ff5f489bd03b5897a97a8b32a425cc224aec1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd062ad6e783881c52779cc5b040348815715ae08dde3a8245240ade4757f0c3"
    sha256 cellar: :any,                 x86_64_linux:  "6395b4d3025414fd8d9e19fd962ad968919d97b90c89a1591790341b74203dde"
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

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
