class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "99da52c3d14c7bd7e528d9e84dbf8e7261a0ef216c8af4cfaf59d173707fb283"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cf71fe457fbb6c7e94a234f8020c5c5cc00712592d9fab9866f1693f234ba1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe52ba64c877e89c68aad133d11e58d917ebfe4abb643bfeecfd57a6c8ea3f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f067b4ca7428d777846329740e7b53d6382f6b08986b47b480d06b4c9b8e44a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8a04c4f5713eb75c41e1be5c7f59614b5cbc829ba3849d784fc52cf93edf116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15c25cfe4f443ce24ca7e1af4e2e63f1a4c10ee397e9ceb57ceb44999dc3b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ec594a3613caeec32e3ff374d01fb31f5e00f0c1714b88e272a54166796b30"
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
