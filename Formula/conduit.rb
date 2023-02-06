class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit",
   using:    :git,
   tag:      "v0.5.0",
   revision: "eacafff5bc575f14396a95c8fd402b8316c1dfb2"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  depends_on "go"
  depends_on "node"
  depends_on "yarn"

  def install
    system "make"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}/conduit -version"))

    require "Open3"
    # Run conduit with random free ports for gRPC and HTTP servers
    _, stdout, _, wait_thr = Open3.popen3("conduit --grpc.address :0 --http.address :0")
    sleep 5
    # Kill conduit
    Process.kill "SIGKILL", wait_thr.pid
    log = stdout.read
    puts(log)
    # Check that gRPC server started
    assert_match(/grpc server started/, log)
    # Check that HTTP server started
    assert_match(/http server started/, log)
  end
end
