class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://github.com/istio/fortio"
  url "https://github.com/istio/fortio.git",
      :tag => "v1.0.0",
      :revision => "b508c4b471a13fbe9f2e219ab6091e8f688b9836"

  bottle do
    sha256 "ee32e53497cde10f8b149bbcb8e4942de36b097c084fc221cd8f4913e5051b13" => :high_sierra
    sha256 "c6e3e459b740262d2ae9093b9456296c0eb735da38575d697cd7b0489be56475" => :sierra
    sha256 "1d8738e857e9a47c6c2228dce8fce363dd31105c2c61deb276a40f5b81059e4a" => :el_capitan
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
