class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "1a47ed5aca892c9d0c55bfbf059b0efd8b75ae2c0140407f4d48f29bbc15d62e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c4f19ea996608af2505fe674040d8f3bb4f49a8501768ce42ec850c7ce0a678"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a6ece1d5e77815cf4e984f3f799aa1c54d19a73cf3b85bcafc93d74488fda14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8171e6b957019d8a8df4a61bc5a3f72e30525bfc77b8c5f141bc37d91f4b8727"
    sha256 cellar: :any_skip_relocation, sonoma:        "888b87d1d2c6f6c76c3c89235bbba531fc2b5495790ce59be051f126f493cc6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "256afb883fbf38fb962ae5620638ce8bf5cd993f6d97dd1569d97f95e70ee4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "969ef2aeac90126e91572983d6006e9ea259a692fd2a3bc764fbf4539b84bbed"
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
