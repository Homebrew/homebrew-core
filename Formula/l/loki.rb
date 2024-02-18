class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "d8d663b3fedbf529a53e9fbf11ddfb899ddaaf253b3b827700ae697c21688b38"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "350828a9c6ad44eae654efc7a67e34291d2efc98bee9ebd4800f7727c1fa9503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbbcdc0d980918e9f8109cf05b19f6d5b9fd3b6018331275bcbe41a09dac3a3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b89a6c6433a384802320d4f58c8d5fdb8d0effdcc0fa1fc7e1eee8fbd6a2d322"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c1af770fc0864c4b741f2eb4cf848b0eb89943270f2ec2b8d138e1758f6c3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "7ce4d6ee93de86a665ad1d1ad4b28768fb30a30e01719f06969d01ddc0cec8f2"
    sha256 cellar: :any_skip_relocation, monterey:       "6099df852e8d839966d469bac97be112cf6205a105d10108df56f283db46a50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c9bc9568e4a73234e9dc17e9302eeeaa9352b9cc9a88dc76c40d35a0010d56"
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
