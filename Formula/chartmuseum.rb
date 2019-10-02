class Chartmuseum < Formula
  desc "Host your own Helm Chart Repository"
  homepage "https://chartmuseum.com"
  url "https://github.com/helm/chartmuseum/archive/v0.9.0.tar.gz"
  sha256 "e5fed41b098141a56037340ad3b0857c7defae6d143af56b6003a270cc75631f"

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"
    ENV["GO111MODULE"] = "on"
    ENV["GOPROXY"] = "https://gocenter.io"

    system "go",
        "build",
        "-v",
        "-ldflags",
        "-X main.Version=#{version} -X main.Revision=9382222",
        "-o",
        "bin/darwin/amd64/chartmuseum",
        "cmd/chartmuseum/main.go"

    bin.install "bin/darwin/amd64/chartmuseum"
  end

  test do
    begin
      io = IO.popen("#{bin}/chartmuseum --port 33333 --storage=local --storage-local-rootdir=#{testpath} 2>#{testpath}/output.log")
      sleep 2
    ensure
      Process.kill("SIGTERM", io.pid)
      Process.wait(io.pid)
    end

    assert_predicate testpath/"output.log", :exist?, "output.log file should exist"
    assert_match "Starting ChartMuseum	{\"port\": 33333}", File.read(testpath/"output.log")

    puts "Test success!!!"
    exec "kill $(lsof -t -i :33333)"
  end
end
