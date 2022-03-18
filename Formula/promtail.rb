class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.2.tar.gz"
  sha256 "725af867fa3bece6ccd46e0722eb68fe72462b15faa15c8ada609b5b2a476b07"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a34837c96d69d2b3cbf662cbd104254fe651e6459d7940fa39eb2346f749cb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d93f3b3a2686e61ee90d73c7ea2303bcfabb4b6f1476834296481d6e872ef52b"
    sha256 cellar: :any_skip_relocation, monterey:       "18725b2acfb54672963511e4d93e498cb2b5c344b43caf235a6e57b05df72bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "770bae3eb309b842bb9d7851762a44d79514f346bc560b2f391a32309127c9c1"
    sha256 cellar: :any_skip_relocation, catalina:       "7ccbfab03c5edffb1d865432652ad980feb7f6b38229e5379b7e78d7597a9e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355b0dfce83f87f0f724dc1e2b69ba302d266e6e42e6390f86db06112ff8c657"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
