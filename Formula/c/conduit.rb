class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "299848b7ff39015d4cf8f9e185ff2e89e48ecd6fe9d3f645129833f47bcbfcc5"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7298f0f10e042fdc70a08407d9341d5797a673217129ea456a46231fa702f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e69c93a1527fddc375009caab96e16b8ddc8f89bad1910d74151b1ed53a4beea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb170c93ae24b7b17e2b6d241a5d64971988d0c68e948792c6a7f72a0d87d8bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c415dec56e651d0a2a2f0c07ec32bc7bbb978941ded677e6373c8eff4d56781"
    sha256 cellar: :any_skip_relocation, ventura:       "17022cfd31d1bc7e8a25c7ef43b82d7487d17384ee619807ed4b93788e2b1842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4641affcff469da4ff258d1ebe26dfe8e699f864d1e05befa7c07a62cb43ed80"
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
