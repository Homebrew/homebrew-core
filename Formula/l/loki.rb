class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.11.tar.gz"
  sha256 "f4aba5fa2867d60e77f08b0d9e7d65bfae79502bb85c8b56aa22206b2d3cc3d8"
  license "AGPL-3.0-only"
  compatibility_version 1
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "72ad2f379d5f3b100473fdb0c76803be09ecb0329727aee0a254521be182f2f2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f4bcbfc301867c159230de2b4e477c26c8df86a608ccea6be58a1ab7b872dba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e65c3e4c24028c7658674d20c228cb8308437985859361d2f647d8e5ca68ef8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76c73aeccbd781850cfe28b8bef5e01765fd2a2ce16a42d9aa4d973dff897175"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fd10238c12e1dab363eb1a49deb82b58983dca474b20f86e2958b8928b9ecb45"
    sha256 cellar: :any,                 x86_64_linux:      "5d36dd36134c884aa42952f11990ae6d4a51e8dfc3de4073da689a906fdaacc5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
