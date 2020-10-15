class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v1.6.1.tar.gz"
  sha256 "25d130f47aa4408ea9def4096253a37d4df4e0c44bdd59aa7e9a69f81e6fbd17"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "130981f7347099308a00b999953d7233fb4f793607e06253a8d310d0bd1e77f4" => :catalina
    sha256 "707888b346c37ba3deee914f1c44551c055ec4de7fba4d6a72803ea1a1d05a24" => :mojave
    sha256 "16e78a76040d4da26f3e88accc19893bb33b5b84c0ce0a2b10ceaab9e807d1e5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
