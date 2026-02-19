class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "4747b7a8b1cce5a32490ff3bb9c31e0d0cb4a97da75e2d4f9f97a33af9a8c4f1"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118277b357cfc6c3d7f2696c118bb887d70dfed444d7b582da092cdd2108b62b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73e20dfa33416ce64040037ca7598f323225b06bf11ff7d9caf0992e7bb0910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "badd297ac7b2138dbdfcfb4fbe66459a7e5dac5fbeeb6f7d81ddeb919978ad94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53d9b586efdc7a2e87004979dc51313c4858388b9d8a3aab4610843cd0a83b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ca928abb6ada159254a94275ab9e9b7c67f2e310be6278ac24e590b340a724"
    sha256 cellar: :any_skip_relocation, ventura:       "cfed5653e00116ee2b17fab9b0678514fecef893e04e58de7b46bbbaf69d8338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f3a72e785383509d2ea012a2a9502c3de4cebb273300693e38464d4a9dd259d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ce98054ac53225a6aa027d7b5929a116e13dce0bd82ea35887fb0b6c0913922"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
