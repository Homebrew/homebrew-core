class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "5471e260bbc012dff371507638967e74cafe0855a9120e4fca00bceaf4ae6964"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7cc059740936b2ffba25aa117ad492faf946fdc0cc73f82776af32106d639e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e43e59c48089d251bfc510e7f97b5b15fb5119b37e90f27c2f9da5c9de3cc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb856127aa558df7a9cadcc44c1bb78140825f91071101fa19c711ff39dcf06a"
    sha256 cellar: :any_skip_relocation, ventura:        "1e48305c3adea6efb2d23b54bdd0453cb5c0ff9cc089fa17bf9d6b669da62d67"
    sha256 cellar: :any_skip_relocation, monterey:       "53489ade69049bd3def93e11d7e7a1d1908bad6609df91eecd13e27de21e2529"
    sha256 cellar: :any_skip_relocation, big_sur:        "0657a92732ca32a34c524fe558060bdf1dd53acd15834d29c2e1e8c893433697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04c164c63e55e7056c38041e6591fb7c843e58e481cf33f32318b67cc19429d"
  end

  depends_on "go" => :build
  depends_on "node"
  depends_on "yarn"

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
