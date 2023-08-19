class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "07fa598f12845abeeaf6995962fecbe1a7a76606f4b27de9c6dc339c1f2949a3"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7d4becd71317b3362cd783791550ddc605f95fddb2be6b2534a0a9ca252fdc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61ebba7957dc368a769437323b3ec835d2b45c707d2d1e2e0ae955ee774bcee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67597f94d3b0055755ded22b31a423fd83ef6886ede4f0d13d449a548f39b2dc"
    sha256 cellar: :any_skip_relocation, ventura:        "d5f823d390b31a2409ec53d5d0e142a2fd4d89db9da1f2543d0e30190c777493"
    sha256 cellar: :any_skip_relocation, monterey:       "40c8a06de117bade95a80267ec043f76ebecca256ff745e478d655e6dd79f23a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3914437b4f4f37cdc0777464057208a2699ef4c2b4d78524f3db8599a4373779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d5b0f0c0b952c8473d322fa93fb0230ea1b354ea1fb9d6d399f84caf01cd33"
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
