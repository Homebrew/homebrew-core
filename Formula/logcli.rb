class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v1.6.0.tar.gz"
  sha256 "6e83ac7b436c5721e914d23b56a8cff41118f81dda40b57d92aa8d8b2cf11834"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e54c343b3d2f59c89074932d84d860a63c2f554cea4d318788168e92ed359d4d" => :catalina
    sha256 "895cd722c06b619fc35dc8cf34b43f0c500ebbb35ed658e53faf20b7f5f85ad3" => :mojave
    sha256 "f82e423546fe2428c2491410f6497a6b132390ef54e5f1cdc92be6fa748a2f62" => :high_sierra
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
