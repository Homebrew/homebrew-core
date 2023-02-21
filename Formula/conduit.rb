class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ba57506c17a99356c443d3c4459977c825dcce1b039965ba7699140e11d95afc"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  depends_on "go"
  depends_on "node"
  depends_on "yarn"

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}/conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec "conduit --grpc.address :0 --http.address :0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    File.open("output.txt", "r") do |file|
      # Read logs
      log = file.read
      # Check that gRPC server started
      assert_match(/grpc server started/, log)
      # Check that HTTP server started
      assert_match(/http server started/, log)
    end
  end
end
