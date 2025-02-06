class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "836ee4a93124193195770f97f3101353909722e5a317411ac409ed49517ae2b0"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00181acc7b10dc104d7f3301bae9dc5db7483ad9e7c35e1993163c79382d764a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d72e4af15f13223048b4646db034d47bb2e92ce755b5ae5621473135d2a0e130"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49a0733a829897ad2bdb5e56d54d17ca4132be2731b0ab490d00bdf890e892ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8a185971d1b7f1731306ffc2c492e9d35a0d66afaabbd930cae2900573fbca6"
    sha256 cellar: :any_skip_relocation, ventura:       "06e00255f771c93328976c24c8fde08d808600c0217297ade1e7ba5d12ed032a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f74708ffd5a721f45198ddccfea82ffe11d7d83f56aaef2348a4203e2edeca9"
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
