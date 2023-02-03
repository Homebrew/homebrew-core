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
    # Run conduit
    log = shell_output("#{bin}/conduit")
    # Check that gRPC server is running on port :8084
    assert_match("grpc server started address=[::]:8084", log)
    # Check that HTTP server is running on port :8080
    assert_match("http server started address=[::]:8080", log)
  end
end
