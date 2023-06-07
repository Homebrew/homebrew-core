class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.2.tar.gz"
  sha256 "6abc2b7aed5e41ebaa151100ca67cd5f33a85568d112b89b2c525601327d6a77"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4acf5af0499e44b3b3dee0e526f748ffcd2c3c8cda08e0291464fdf1d0868aa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4acf5af0499e44b3b3dee0e526f748ffcd2c3c8cda08e0291464fdf1d0868aa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4acf5af0499e44b3b3dee0e526f748ffcd2c3c8cda08e0291464fdf1d0868aa6"
    sha256 cellar: :any_skip_relocation, ventura:        "7c613daef586535daa9ff27275b6f35ccc3eaa6919cf3a4ec933c60686f9af90"
    sha256 cellar: :any_skip_relocation, monterey:       "7c613daef586535daa9ff27275b6f35ccc3eaa6919cf3a4ec933c60686f9af90"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c613daef586535daa9ff27275b6f35ccc3eaa6919cf3a4ec933c60686f9af90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc9aacadae2025883acdcbdfc4aba4d51ff80661d3adb3024647a2610bc9a70"
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
