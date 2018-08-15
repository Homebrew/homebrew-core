class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :tag => "v1.1.0",
      :revision => "d13f3b92c63db22136bac4e0896562404bd4ef6e"

  bottle do
    sha256 "9f383a159618023334af96f850ca159115f4be8c52cd9ff0bb752d79fd962ea5" => :high_sierra
    sha256 "0cae47563c0bf4373858329aae4bb60ae19f6b78ec3d084cc36a36e891a0e01c" => :sierra
    sha256 "b60701c47ad35b607779a2b2396b6367bb005ccd12b769089cb1ac6d0cff1be0" => :el_capitan
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
