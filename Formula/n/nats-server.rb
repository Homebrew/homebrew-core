class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.4.tar.gz"
  sha256 "df0baaf9d5db37ad4bebc222fe905d16d80a24fbad3f26e803b286c8489ddbc0"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b6d9772cdf8518cbcd192eac2b0a4fcbd07f5824e2f18f19eb7a2e9b85daed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b6d9772cdf8518cbcd192eac2b0a4fcbd07f5824e2f18f19eb7a2e9b85daed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b6d9772cdf8518cbcd192eac2b0a4fcbd07f5824e2f18f19eb7a2e9b85daed0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e3eb3bbf6d0f9e1c24e8391fdd3c7081b1d9aaa44a069702cdfd7e3b85c53f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e121b2564e1de36c0dd3813d6a2a06de71dcd3a3aed68c6d6a3f11bfe6db96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb95af2e92fe838f6091302aaa65b677a1419926f3e89860e829311ec8321225"
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
