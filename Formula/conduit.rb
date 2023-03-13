class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "812e11636912cdbd5d0434b25fd305c3854c946aa73d6e83537584e54185d7fb"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c1ca6c02997b7258b8c4e3e0468d3b5c16d1bcdf89ae2fd77cef55afb73febf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aead63dd26e90369e0db8daf6225c0a960068f4b1564102d613c9987e69381db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "587777cb3f9031c9bdca37c75e61340349c310c7c9a6be002eb47bf8135aeb04"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea9a345a3e3106b72b61d79f643dafc02724052504fa373d9893dad06a96b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "daff1361164257a24f2d1f82edf85b202cdb01b821be539ea32f2cedfa67af25"
    sha256 cellar: :any_skip_relocation, big_sur:        "e24311e73aabe7d0d9db273ffb8a5055b57d1c69e4697dc5f49c613260800291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809e7fea25a55719189fbb12e53f05af3155513b831625f47ce2833d38801880"
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
