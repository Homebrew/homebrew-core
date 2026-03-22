class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.7.tar.gz"
  sha256 "28daa4ee3633c8cc45bc6d62a7b470216dc502ff97cac46eb2d5fec228fd498a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5656ca1e872d46a3ed0005d056acdd4da55485209894a3b77601c7932bbe6ec5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745e2491beb83d80cc679c9cde0b2e0cb173b1b96bf042dd8bb1b38149f8dc99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e83262ef871598f86694c85b293719a10058c9ff0d3cfbcc7093781fe2bb220"
    sha256 cellar: :any_skip_relocation, sonoma:        "12352e118f8fd30ddab4d099680afe1ff398b11d41aa27e8f2e6386953112182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "446f836e3dcda523f08bdc445725d968c17238c98b21630b24653b1034bdbcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9364f647318663802ab9db8b5e7bdf2e1727343af7c22c72f58a1ab11b093c"
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
