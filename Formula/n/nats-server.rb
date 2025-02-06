class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.25.tar.gz"
  sha256 "7aa9f5dadae4b46cb98dbb3c378d03e125f3ff5dfa1c604bdb086351bc4e6c31"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b479adc7b2ccdd8889dce45ae0a0cd2a307b26481ad34980f483caba1e2b047c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b479adc7b2ccdd8889dce45ae0a0cd2a307b26481ad34980f483caba1e2b047c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b479adc7b2ccdd8889dce45ae0a0cd2a307b26481ad34980f483caba1e2b047c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef1ec00a8c81c9cd3e7efc95d79493d6c333c93082b76787013c8766ad395cc7"
    sha256 cellar: :any_skip_relocation, ventura:       "ef1ec00a8c81c9cd3e7efc95d79493d6c333c93082b76787013c8766ad395cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e2a73db25278a0392cbfd4380a5d2a083a15cc350ddc8898c60f76679f9f7fd"
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
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end
