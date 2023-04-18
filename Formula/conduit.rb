class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1841a7d9343c9c0ac56185046fe20bdaee20c0e764b31b3ea090158e347ee728"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa881f1291afacaee3af3b0a18eab308c59f22bc6ef308d6b2bcce9cdced9325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99e77fa49ee0a1742eeaa042420635313d7db38cceab100e1538a0ebcf67dc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13fb3eeed2c4adf607019b81011d8fbe09c01c908537167ceb6b69907aac9293"
    sha256 cellar: :any_skip_relocation, ventura:        "922cd82a9ef0bd75f1edd3be76258ec252f592115742718493d57698b22cf647"
    sha256 cellar: :any_skip_relocation, monterey:       "f24b84237bfa6a82a0b002255a53da17c43b2ec32cd2832c306839d033daa6f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8ac89c86be6f89733f7bd942c857dac2e0386971d15a7fd6f2589629b6138cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5851d140b8f37e32c655a0757e919a5bf6e15b23958a53d0025f3be28fc98811"
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
