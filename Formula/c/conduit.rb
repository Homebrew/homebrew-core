class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "96dc9b58369025ef60d877ad776347c09b80dbb54800253936655489bb2273e8"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7442b88e26aab3468f3f967cdd1247a18be6d0dabbfc4ec1cbdbc9b781a598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d293e397e3869b6935453839173714658107b75c6996326c28bc66d31c6262"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fbe86a1172ecd47dba7a7820959d492d67df7a5203202aae83c842b64031cee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c2f24df3998e0b26beca132b9da9465af1044b020e68c98c10d046501e07d24"
    sha256 cellar: :any_skip_relocation, ventura:       "b6d70e9f5d3994cd95c8698518e22747073867dca197c9c4fe4866d30b958498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f13b176d8a74de86b8f81c670017178b2a96fec5a911572e3b6c35261dc81a52"
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
