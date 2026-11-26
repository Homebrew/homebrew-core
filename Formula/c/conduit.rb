class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "4c1d4e556a404efbde124cc827ce874ddd2d4ca55cfe22f5734ffc19042ca730"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "189b02a40ceeba50b646438990978497ef99c89c1b23fce6616c73ae98bfa464"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9037a369f237f49e4284fb35f6bc4f177af4383038c0729a9103bb59806be02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb45f18df5a2a595fac4d3a5378e767e008ea007515a497b40340dd85bd27835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "073f3c23a17e645137569bac2493453170365ab74572564e9bcf2f05b3632a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f992f1e7419322e4849af38087a2382ad27cb601aebd7dc05d6098915b12167b"
    sha256 cellar: :any,                 x86_64_linux:      "61a598b287d1b34e6d0303eefe6cacd610fc5be2a3b663df918d9e990f03bbe9"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Drop the test files the revert patch deletes but `patch` leaves empty
    %w[pkg/lifecycle-poc/archv2_batching_boot_test.go pkg/provisioning/boot_start_test.go].each do |f|
      rm f if File.empty?(f)
    end

    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", "127.0.0.1:0",
                                 "--api.http.address", "127.0.0.1:0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
