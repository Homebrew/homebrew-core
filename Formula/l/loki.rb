class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "de62ccf933e49a8db7cd3d375a28c69c2d66b0c2b64432cc6042f9137ad427b1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8104980a420a8ac87f08959de27c49409701d6b6819df3ab940ecb2ab236e859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b552ab8db1a864a95df7e84b8c74ef20c507359b4ca05905abaa8fb9fcc5f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5a2959619df43282704450835c6deda581f5adf7d3d905e2dc516866f406f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c160f34c2937bfcdfd129fc56d9d26bb99affd8680a585dea79c9cdd851e155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db6456b97c6361b03c2cde191f651db4d6259040a161304e6fee749ec2d36d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603f643d4cddff3ecf1b34cb716ab093ee095274e6b388bf2f75853084579b60"
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
