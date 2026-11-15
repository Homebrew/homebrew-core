class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "89a5d436beeb7152428fd22e75cbf25490d5e0d727503b8790ad8d6e10e2d8ad"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "926ad2cda8983575174472a9bebfda24cdb515dfbcc35eeffb1529509a1bb69b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32a1e9db0e672f45e82b5590f42192ff79ec6c74eed3359956a2c8871feb4d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7bec45277a904e354dc8ed2034c34b5042947638bea621249e962b3a5e75bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ba1ca275f5e4ecebef75f3de37cbd7833130b5dc4c8210730d78e4627408c1e"
    sha256 cellar: :any,                 x86_64_linux:      "1392e7d39aa55d4c573bc1eab353693193d65605ade0d64f487b941856c00f77"
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
