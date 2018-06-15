class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :tag => "v1.0.0",
      :revision => "b508c4b471a13fbe9f2e219ab6091e8f688b9836"

  bottle do
    sha256 "c88b6cd61fe7067868ebb3842698e6343bb3f1a43be708723ac1f57a1a7cbb72" => :high_sierra
    sha256 "e7220576eba0318f3b51c09552d1e3171347992c8f6ac8f33a366fc4fac60531" => :sierra
    sha256 "ff768abe78f7302b6da2ff08dba589c3f4beb40742b3a17db64312e82e4e074b" => :el_capitan
  end

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
