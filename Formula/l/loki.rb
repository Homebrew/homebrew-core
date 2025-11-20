class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "0be8473755ad90877f2e0b6ba807ff40d5ddd952dae653b967bff32dc58dd4e7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3e0b521470c857c155ca82469da4a3ffebc94b8eb14668000aa61f40f36dca3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ba10b06f3f34f368121ff005a36793eaf73c2a30ac5f394c8753f4f11cebff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea59bc37506851466be0f17c67021bfedd6ff1324d35341c5e78696a2a7fc3d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "99f676f8a3a34cf896b4ef3f54e1f4df08634360001d03cb94f7025a551f8f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead0b1bebc0fe9942b82e9e8cf73247f659265b1e4e23a63ea392225da4ba9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b2df3c938eddb0e94737a6848ac546caac6aecd650adf1bcc07772e13b0aa9"
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
