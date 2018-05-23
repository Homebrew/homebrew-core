class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :tag => "v0.11.0",
      :revision => "d17e45b4f794ac1722747d7cfbcbe0479722868a"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/istio.io/fortio").install buildpath.children
    cd "src/istio.io/fortio" do
      date = Time.new.strftime("%Y-%m-%d %H:%M")
      system "go", "build", "-a", "-o", bin/"fortio", "-ldflags",
        "-s -X istio.io/fortio/ui.resourcesDir=#{lib} " \
        "-X istio.io/fortio/version.tag=v#{version} " \
        "-X \"istio.io/fortio/version.buildInfo=#{date}\""
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
