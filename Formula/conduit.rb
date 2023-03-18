class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "812e11636912cdbd5d0434b25fd305c3854c946aa73d6e83537584e54185d7fb"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e50ad4836b15bb463a0e99b8522b0c2abdff07258311ce565f6fd1a9c9678239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5767e644dfb899b43267344e5736acffa8a9f33e844468e68c25513d4fa690a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f55b7ca9ba849a24dd279107c0af399eab6e2eabd42599601e7053e836207864"
    sha256 cellar: :any_skip_relocation, ventura:        "b151465fb6b6ec29e8a4769684fa86ca74d8a352b1f49119cfa415d0275db763"
    sha256 cellar: :any_skip_relocation, monterey:       "e26272fe781aa17ec24944cb326e73053fa1abfea8581ff1d4a0850453567dad"
    sha256 cellar: :any_skip_relocation, big_sur:        "510c797952b92e8087c388865be183edab509365763911a3fc5fb8fe4759a744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "458cee5592cffafead992b7f37644fa84eff7bc7d5be4014bd1c932d7e15c966"
  end

  depends_on "go" => :build
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
        exec bin/"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc server started", (testpath/"output.txt").read
    assert_match "http server started", (testpath/"output.txt").read
  end
end
