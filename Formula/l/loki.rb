class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "4d39632d6cb60a3252ca294558aa7eff2c9bb4b66b62920f4691389d293b6d7b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b5725129da9fb946bd0223c68c75a5be4502afb83c1971841c89358196057d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5acd3974a562d43da8788124a8431a71b518be594f9fdb29fc4f91c4cce60290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b609758054872182caab7089a4c7b5dced4b89e00f01b4c72a766a64c0e7821"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c66c4fbece6898c9c9d733a8bb217911810e776c0e83418418e0df771e71ed"
    sha256 cellar: :any_skip_relocation, ventura:       "85db50a8f3a447d6dc513aed1f1c4802ae11eb43bd1ed40eb52d6d93f2d757e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07d77f8dd183254d7d14e6f16dd800cb4f7f05014fb8c49e65c3404d31c6ddb"
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
