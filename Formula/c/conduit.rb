class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "f857d0a2bd97265a11b84a763f2589b7e8ee5964ee5876daa86791214ced000b"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7738e6231513ebbc3afd69bd467042a1387d8745a8894e49fd82b8df1756df42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad00f6d82c4b5a2fad357a2d734e37e91047406a2a153f13873009e12941b4c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95824abb3e2614aba46a2c431020ec7b9af566a7ca577e21deb68a11f2dfb0dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d309919e78588542b0700c5a5647ba10540c2263b34261a3efe12ba31e65a82d"
    sha256 cellar: :any_skip_relocation, ventura:        "b462dfd50ca90cca599f0564c9869e045e1d62b9eefad13bfba6e7d765c53986"
    sha256 cellar: :any_skip_relocation, monterey:       "fc68caa90201d43f10a0f59fbb72ddb0deae70f7870ec896ac68485a08a6663b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eaa152548ae503742631fa96a44dc3849da2f7fd3e5865cef4958bb673fde7b"
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
