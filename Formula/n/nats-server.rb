class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.12.tar.gz"
  sha256 "6ed770525c68775507b499c7b32a4545c430b929eb657addf759f350e9cd5e7b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aaec43ada2e9e20724b90f5b6f833791dd64a990a045edd0f2d7e52cb3f7b65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "295044c294dd1c3ac1750ff897899900d9152ed2d5580e0e50e1b3ae4177fed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad613ecbe124000720e90bebbfe104a93deb3b6617f2c3493d554f0f4f64103"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbcb5bae5a10c76638748f3dc3bbb0a63a10986245bb0b4727ee10deb466b854"
    sha256 cellar: :any_skip_relocation, ventura:        "4498a70e7cca6587d81bc266bf5360d1dc3592f4cbe0505231961a141517490b"
    sha256 cellar: :any_skip_relocation, monterey:       "7a84afad88743bbf753343fe54d5b3df30aecab60b6db57a49e9db3207748635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de370c60eccdb60513656038c08c99886c983d659459d55761261d2a745ac67f"
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
