class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.5.tar.gz"
  sha256 "e52606786923a346de676ae238889a79f55df61680f492ee5e2b1353b58418b5"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76f06a318a46a1d6a1e3bb898ee1abe48f1131253840e34d41ef321e5b8131d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76f06a318a46a1d6a1e3bb898ee1abe48f1131253840e34d41ef321e5b8131d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76f06a318a46a1d6a1e3bb898ee1abe48f1131253840e34d41ef321e5b8131d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad9c9603f108c62bf46c7e9646537b65cd01d37acd2a2804aed915a1a7899f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e246875bc97245a4144b53b2837a435602016e917eb1c88771ec1425520205db"
    sha256 cellar: :any,                 x86_64_linux:  "e01bdf5abeeeeee261f043a1c501270d3cd811826cf38675b112478e45ce54f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
