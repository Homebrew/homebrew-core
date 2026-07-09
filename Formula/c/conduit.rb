class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "35c60ebc0fb57b4551dccb67806579a5f7ec517804774fcb47ff2d7417a459b8"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "497c57c26209a1f962067f55cacfa8712d4546acbd2f84de1bb530bd5ecd25c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036be0c36f9adbcd5d527e653b46844cc945f795721f539470eb56c1b231bc55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37e1c06d28036031f0c265360f73823ef293208ffeeb53e1397a92a0bce19700"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f93edffe863456e611b633350c6aefc5ec9f1f891c7879eedc7ecab0db77326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2394f2e60cc7732189e2badc69190e7be31995b614de109310f572305121e3d5"
    sha256 cellar: :any,                 x86_64_linux:  "371d14b18ddee04c0c1c85847cc1385554a185007205cd70ab1c79b5a5b437c8"
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
