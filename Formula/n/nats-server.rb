class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.21.tar.gz"
  sha256 "660d5ed95e920377ea26bd23795921ce881816a0ad8a70238de230d44f11f330"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89b46431ed0df1f68b75bbc0e1d1cf98aa98fb14d7871dd38abc7bb9348472a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b46431ed0df1f68b75bbc0e1d1cf98aa98fb14d7871dd38abc7bb9348472a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b46431ed0df1f68b75bbc0e1d1cf98aa98fb14d7871dd38abc7bb9348472a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbf27e32359dc71bd240a6eff48145b80fb035a07872962cf7b4debf95d7c8e"
    sha256 cellar: :any_skip_relocation, ventura:       "7dbf27e32359dc71bd240a6eff48145b80fb035a07872962cf7b4debf95d7c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0bb3330c98fe780a9bbece94c45c342557a5639995f70199f3fa339a44b9aa5"
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
