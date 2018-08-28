class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      :tag => "v1.2.0",
      :revision => "36bffaa50c7cc47038fc7572c83221640a603425"

  bottle do
    sha256 "ec027b129bf54d10cc153a617df246bc5a356cfb2c39915340b45f5cd54ea024" => :high_sierra
    sha256 "69846957b5049c2fa3eb835a21651e8c9675d36d69a042b464e929c166111c18" => :sierra
    sha256 "95a65023e84f7ce6bc05bca350c2355e21ab8f35af8c04546e0a4482119cc491" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/fortio.org/fortio").install buildpath.children
    cd "src/fortio.org/fortio" do
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
