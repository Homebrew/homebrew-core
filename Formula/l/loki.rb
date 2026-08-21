class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.6.tar.gz"
  sha256 "0dd21abbe613ff51807e4e58cafe4ce71dd1561396c4dc7eb4d7f7e8f577baf1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "339d3f75b85af2be055fbc1be019eeb2985505f2df9757e55e8b1c684059fd69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68572c6885256527007d0a794e94da5afc77f83b98044089096af7bf2dfc384e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7c0088e91c04ec53752af46ae942520f09eba798731277a3bf397169db700e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ba8cb2ceb88ef1752108aaa567bb3bb93a489807fee28c23bb0b1074bf06a1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0edbcb29cffb0f54437a72d53ab8e0502ac65659cc0863aacfb121f1c12b452f"
    sha256 cellar: :any,                 x86_64_linux:  "f514a2d514562251b5fc59ed547193b67869bd4f30a1f7401ef05438763ae35d"
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

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
