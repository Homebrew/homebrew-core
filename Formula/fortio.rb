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
    ENV["CGO_ENABLED"] = "0"
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/istio.io/fortio").install contents
    cd "src/istio.io/fortio" do
      system "dep", "ensure"
      date = `date +"%Y-%m-%d %H:%M"`.strip
      link_flags = "-s -X istio.io/fortio/ui.resourcesDir=#{lib} "\
        "-X istio.io/fortio/version.tag=v#{version} "\
        "-X \"istio.io/fortio/version.buildInfo=#{date}\""
      system "go", "build", "-a", "-ldflags", link_flags.to_s
      bin.install "fortio"
      lib.install Dir["ui/static", "ui/templates"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")
    fortio_srv = fork do
      exec "#{bin}/fortio server -http-port 8085"
    end
    sleep 2
    load_res = `#{bin}/fortio load -quiet http://localhost:8085/ 2>&1 | tail -1`
    Process.kill("SIGTERM", fortio_srv)
    assert_equal true, load_res.start_with?("All done")
  end
end
