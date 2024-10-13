class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "480994460326bf3a3723713e7385d8f02b16f00f7fc1db8ee374f7ffe496e6ba"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0872ab7bcdb48c30adfdfac2cfa074ed91a38a844cff30e1e58b91ef3637268d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdd399ce349ccc3dbe018633ad1246b10b9cf49c0cb212cd2fd77098b1a9347c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce4f69dea696a2b60fbcf002aad3f9e9e83bc4eb5c63b421c49d0a6da5aab88b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b9dc90acec4d4652d1cb928bc66f8f8f0b3670f4a0702528906af69e6d6a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "f79c108fa96653ca6cab978d2f73023942e3cd1cb2347ec5f25e6a5fce4ff3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5669b934c60e13a35ee40afa74684066f4cf8133639a2dd84ed8cf1769803002"
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
