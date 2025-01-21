class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "cda35d6ddafa5b4aac7607cd0ba3438658bb806a8c114f28fec3613c007cac03"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68987192d70edccf62cd031b7b3a98c668f2aada0a977535f49318fa86298917"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e32ae6496f7edcfa24ecdcfda79f74c0fbcce94fadc631c52a0fbb30a59d9812"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9123b742930841b6e8a62178faed6d629b3e078c1e6d07b122795b25da021f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "181108af97da9729aaf4a55e25a2929d0a4f3797adbb7593f032f372352ba2b9"
    sha256 cellar: :any_skip_relocation, ventura:       "535326d8fd62d4a634f116d2de4cb3c418cf49b3fb3766c99e70bfda658eb613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "236d33d23dda258b4443464c0898a925b5afe9fd8040511b2b9cc9dd0b48afb3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

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
