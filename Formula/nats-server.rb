class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.17.tar.gz"
  sha256 "9e2042f988900c68ac987c3295220bb981884dff30276e69294f8d95463a54e8"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d862d2a514a8eef4198dec190c92099120116fa4725a748c4e1013c24b16972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d862d2a514a8eef4198dec190c92099120116fa4725a748c4e1013c24b16972"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d862d2a514a8eef4198dec190c92099120116fa4725a748c4e1013c24b16972"
    sha256 cellar: :any_skip_relocation, ventura:        "430d2872f6687cf49cc5e3758a6cb4513dafb0b6caaaf2246914f1cfbc485da0"
    sha256 cellar: :any_skip_relocation, monterey:       "430d2872f6687cf49cc5e3758a6cb4513dafb0b6caaaf2246914f1cfbc485da0"
    sha256 cellar: :any_skip_relocation, big_sur:        "430d2872f6687cf49cc5e3758a6cb4513dafb0b6caaaf2246914f1cfbc485da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb392cb828c4ae09e6f606ba3a2cda103a88f6f9e6369616ebb1198da25aeccb"
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
