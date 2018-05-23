class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio/archive/v0.11.0.tar.gz"
  sha256 "7f30e61593473c1172805fa8ecfd4c7f31e02d4005630a4ce012f14165778582"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/istio.io/fortio").install buildpath.children
    cd "src/istio.io/fortio" do
      system "dep", "ensure"
      date = Time.new.strftime("%Y-%m-%d %H:%M")
      system "go", "build", "-a", "-o", "#{bin}/fortio", "-ldflags",
        "-s -X istio.io/fortio/ui.resourcesDir=#{lib} " \
        "-X istio.io/fortio/version.tag=v#{version} " \
        "-X \"istio.io/fortio/version.buildInfo=#{date}\""
      lib.install ["ui/static", "ui/templates"]
    end
  end

  test do
    begin
      assert_match version.to_s, shell_output("#{bin}/fortio version -s")

      fortio_srv = fork do
        exec "#{bin}/fortio server -http-port 8080"
      end
      sleep 2
      assert_match /^All\sdone.*/, shell_output("#{bin}/fortio load http://localhost:8080/ 2>&1", 0).lines.last
    ensure
      Process.kill("SIGTERM", fortio_srv)
    end
  end
end
