class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.2.1.tar.gz"
  sha256 "4801a9418c913bcca5e597d09f0f7ce1f5a7ce879f8dba3e8fe86057cb592bcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "575dca679106ab8ce08f4424a1b56222cec4f95ac593beb058846c6333363ce4"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fb693fd292ab4918059c8c24d638ec9739273a75489e211a79fbbeaa06d19f9"
    sha256 cellar: :any_skip_relocation, catalina:      "112e29ca1fcc7d1814c720711c9d065bd861065bf47c613d2b5be2bc8e6c0e39"
    sha256 cellar: :any_skip_relocation, mojave:        "bd651c8a96c2fc1f3b56a4519b3880e54929962e1e49fb9122ace4ff0fde0ad9"
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
