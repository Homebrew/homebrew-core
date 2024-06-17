class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "828a6dacbd48618a0a33f12690ab348fde2d8beb8c6d2d3758b936fb7ac4b262"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a184c9cfbe8b5c307a7121eea7a2a4bc29de5ff9e2ee11c69293bc20ef68facc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c889165627c73fef2dab4b9f4b32487bcd31a49dd54066ae9b7515bb13e6b0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36640a9d7288be331dec81805d16392cc5d6f94278ab581631d714a389b2fb8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "49486cc0a525bb432db10d56600584e6a7619846cdf3d700da0bb00ae3f0de15"
    sha256 cellar: :any_skip_relocation, ventura:        "8bea0f0aabf67fdf2eb93d776993b041b65fff10343e6ee8950b7c700b9f9c95"
    sha256 cellar: :any_skip_relocation, monterey:       "e4519c885bffc33bdfa1d23bd68ea81f5940087fa32c33482b262720fd97d893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e0b86d8a5a82a4add0bc97ae8f2afa33abe645f26b49c637dde30c2ef9ee4d3"
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
    assert_match "grpc server started", (testpath/"output.txt").read
    assert_match "http server started", (testpath/"output.txt").read
  end
end
