class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "da16e12823640869e388ebbce5e5f1fac73ba0d3b0e360a7205d87177ceaa795"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57c127f3236d7897a62c624c2574b1b3a86237cab99ab920e95a2fd7d17f8a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08901c87b39970bd6f016caef1209dfa885c9db76dafbe5f22bb5ff3333b9fee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbf59cd09588015fc1c96cd72a042ed11284e6c8f18771e3126b0b3c0fdc106"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfc2f661dc17dbd2b8f2f6d404330e308b0b0a393d46f22a7f798a677ae137dd"
    sha256 cellar: :any_skip_relocation, ventura:        "362fcf1cb5fbbaf15f6c996287086d0a5ae484676779137cbab6481b438fa6e8"
    sha256 cellar: :any_skip_relocation, monterey:       "d3cfee5fe65cefbe4fc90c18c10500482689843dfb94232c1deb9fe2fdb4da9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f78c703af12d2d0d1970dc5a33591e4c780bbb836f5c4a932c5f0d95ec0437"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

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
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
