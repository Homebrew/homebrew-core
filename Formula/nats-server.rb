class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.15.tar.gz"
  sha256 "e2f63277776886134683ea08d0f9c39c0e93161b483b295d84180d02454bfc28"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dbf901b9c7421fffffabbb456716d7cd97efa824af779f00511731eb0b712df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dbf901b9c7421fffffabbb456716d7cd97efa824af779f00511731eb0b712df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dbf901b9c7421fffffabbb456716d7cd97efa824af779f00511731eb0b712df"
    sha256 cellar: :any_skip_relocation, ventura:        "445be920c1ddb8646aa4f0f6b3233099e561afcbcc9b86b614af9503fcbd26ea"
    sha256 cellar: :any_skip_relocation, monterey:       "445be920c1ddb8646aa4f0f6b3233099e561afcbcc9b86b614af9503fcbd26ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "445be920c1ddb8646aa4f0f6b3233099e561afcbcc9b86b614af9503fcbd26ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a705cd331058257197d4c075bfcd8c61dc3bdb9cad62638b48c8a66454eea203"
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
