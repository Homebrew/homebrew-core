class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :tag => "v1.0.1",
      :revision => "1e338e499d8ae134dcc32ad63825e7b972158687"

  bottle do
    sha256 "5f6848e1d99731eacaaf649115e50d41169031ddf2f72b0f328d8c519a281984" => :high_sierra
    sha256 "acf51ef22d324e280ec4cfc6ff2d9a5af34248fc8550343ba044febfa5b393e3" => :sierra
    sha256 "9f5f4ac43978e5f0454e91282db31f3f072ff4ce90d043dcd42fea3b97078d66" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/istio.io/fortio").install buildpath.children
    cd "src/istio.io/fortio" do
      system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio",
             "LIB_DIR=#{lib}", "DATA_DIR=."
      lib.install "ui/static", "ui/templates"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", "8080"
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:8080/ 2>&1")
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
