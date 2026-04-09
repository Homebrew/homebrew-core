class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.6.tar.gz"
  sha256 "4e857bbfca96f6703f48bdfea33f3a19a15248cd1b0d0cbcfd377078310ff6ff"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ada26b4cc573ca4c7c1ca2a3fff3fb29351a39ac5c3d7f4fede3a4f2b245623"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ada26b4cc573ca4c7c1ca2a3fff3fb29351a39ac5c3d7f4fede3a4f2b245623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ada26b4cc573ca4c7c1ca2a3fff3fb29351a39ac5c3d7f4fede3a4f2b245623"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1f4cfce1507ee95149ba944bd8f9f2799223f2f479fcc2b24b794ade41a253b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e40905e4cc6f6d6ae8a9e615bed2e724c073311f84498d0abe9f04010161c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adb54586f8ad73b2ac86501e29b94750a2e0b0251616cdf4d37375a50c9a8fb4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
