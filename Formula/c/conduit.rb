class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "16c01a37bbbfa59d146f8bdafcd0bb70d4e5927446e8aa6beaf1bb761e1046be"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51f5d4c9f370a0ea8de95c3e2e7d3adffdf6ccd57e90cd8cbf90b2bdb95211a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fcd34274f994c0085560471eeeee829c243b3c1eae2f1701f953503866a7081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3836193e53f65ece257305ed140193ae722f03b0ea7153bc9c64b8ca28b4cb10"
    sha256 cellar: :any_skip_relocation, sonoma:         "26149e53fe35ebca60faedebec7023d61a55434e5510e97cd66ceb6da26fd858"
    sha256 cellar: :any_skip_relocation, ventura:        "4fec4bf52ee393da1a9deab6638f27289e2fb2d8b693484d7d50404c5c8e1252"
    sha256 cellar: :any_skip_relocation, monterey:       "d374c845f479acae91174b0aaf845ab1711e49f838443dbe0367e4326bcd9156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78e3aa9eaf64fa459639980f2300c4791e3e5a0a0357e87335966fc773fbd5ba"
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
