class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "010c72829f5f58138b3e4575c376bd5e94145f0fec3c0d93f99b76bc672394d6"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59947b1ef69642b5fb94f91e1134859b3c3d8d4c89d476b3617765ec9f11bc95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "614b3ecfbec3922927a08022643e49a9bc1ab681affd37f9b66a5d335ab0d2de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49a4ff3607efc0e5db9b8e6ece8c75d4140c11fad2edaf38129a9e8f469a1944"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86eb9baa6661fdfe04d9b61c83336d370aaa4a967042e06a51e084bd42c76282"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8417cf21f669e71339b4d15bed4f47b93ad7cd0c2e179903b2c337c9640c9e3"
    sha256 cellar: :any_skip_relocation, ventura:        "25155f65a54acce186e9aaaeba67a554d4cc2c42af1cad3dde1d41a74faa14f5"
    sha256 cellar: :any_skip_relocation, monterey:       "048dd98fa78e1558e211b763d356c97a9a10efd4c6bbbf7287ebf11d56ea8434"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6b0de2dd57ac9f9acfa2b51cc8821ca6e819eb8bba53828618b927323426492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd683f616a5b10a8de6d30dc9e30ca42cd2a3aef9f6b8d795066c3844506273"
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
