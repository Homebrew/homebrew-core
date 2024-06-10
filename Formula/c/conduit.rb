class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "6bd16062366d07b98bf71c94f833f11f8d7d38c3742ea9d19946b1814547b5ff"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9f715df091f79a71f41ef2c76a31b2f3dab000e69a038d596ef2d3f45d27001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b05603412b83c6bce45ef697a964eb9dd6b48456dcd78bf1c429400ae395169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6762da3123913bdc056158c741c6f9049a89d2cb9b0c504169bfaace2ac8a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2523971e64b643ef356d25a58b6c56e70ace86a1d07f18bd1073df81577383ee"
    sha256 cellar: :any_skip_relocation, ventura:        "14e3a8d4dbdd71ac7e7448492e4c00758ff14ecf47c4ba4cd65bc08056f9f374"
    sha256 cellar: :any_skip_relocation, monterey:       "33eaafbae052f14f566cd84d7a04080fd3aeb945000287ead3df9814d546a3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92a0a5e0321f8cb2936d909e727827438a6524cf7d3381a4c9d2c7c688e1ff4b"
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
