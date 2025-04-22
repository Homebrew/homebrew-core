class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "00b6b671c1e5fbd52ab1fd014bb8a201d32fe01d9998a28d7dcc933a2c3e5f77"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92503584e00da8c2b8f1bf5b5c9e8f031c0177070a112ed2d3f09f2c7dbd8d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545bb0f7881634f82e62456d35748a47dbe11096d9353de87ed3dcbb210c68a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2197674c9eb4e925cea20cb74f92a1c70503b4c291034d6b941584cc5cf77104"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c2d989284d7746703c015f40c40191bca554d9d8805ae238c34ed1387d77c0"
    sha256 cellar: :any_skip_relocation, ventura:       "84e303f766d7a18ea9ea7a17c29c4d202c3764f22f0b7512f86cebddd3ce5599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4669c32f34a014871f4b005be1f4008b1b9dc12095623ee3ae714438c2d8c90"
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
