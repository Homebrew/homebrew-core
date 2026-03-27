class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "8792142f026f40648043029c0553465721997d439e0bfb7beaf3d47fae8b30a5"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37f5d58a6b0a985aa0cd54db87ca285c7c0ea805631ef03a50329f304551a090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06e890d6c08e41db4fb192839a20c254efb8689c9926abc12d3aae4e02410bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4d051348ac45465ffd1125047150d1aea9400c548f4d8ae7d062be6f4d0807"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b171c59b6ee99debc48a5b593dbab368aff5b60e961adbc3b11199267dc7020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c4173caa6ce74c46bd743fe755b2025827845c93c535e9243f0e84d25c28c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587482d232aefdd9a6e647ab046d3dbc14c5a5caef32f298efe9b17c6cc02cc7"
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
