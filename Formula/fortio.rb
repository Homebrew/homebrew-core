class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio/archive/v0.9.0.tar.gz"
  sha256 "76871124e7abd13d7fa0ccc5ad6912bc1c3d77d53694da2b26ad44af3638edab"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath

    (buildpath/"src/istio.io/fortio").install buildpath.children
    cd "src/istio.io/fortio" do
      system "dep", "ensure"
      date = Utils.popen_read("date", "+%Y-%m-%d %H:%M").strip
      system "go", "build", "-a", "-o", "#{bin}/fortio", "-ldflags",
        "-s -X istio.io/fortio/ui.resourcesDir=#{lib} "\
        "-X istio.io/fortio/version.tag=v#{version} "\
        "-X \"istio.io/fortio/version.buildInfo=#{date}\""
      lib.install Dir["ui/static", "ui/templates"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    require "socket"
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close
    fortio_srv = fork do
      exec "#{bin}/fortio server -http-port #{port}"
    end

    sleep 2

    load_res = Utils.popen_read("#{bin}/fortio", "load", "http://localhost:#{port}/", :err => :out)
    Process.kill("SIGTERM", fortio_srv)
    assert_match /^All\sdone.*/, load_res.lines.last
  end
end
