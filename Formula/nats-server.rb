class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.8.tar.gz"
  sha256 "31ad53e46a3dafdd9dfe52ce751b7fd5eaf838810c42d002b11477ee8d6e3471"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5d8e973cdc70feb67e385bb6c7e188c23920f595bb82a8034e6ab3608cb4c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84b4f7d375ad0ba6223b97193bf8e96eb27dcb4cbd473ae0b206479010ae7692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6c850b47b55d7fb59556bf8908d21ac2c7af4566bae34bb74fe87570169c36"
    sha256 cellar: :any_skip_relocation, ventura:        "81f1c19253705a94f5a6dd81af54a50d92e9c4074b05785280a39d827ac46b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "a73c799a085ee2ef38dc4a56a542287a163dd8260b106bb62b12acb4bbe6361b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7675834c2bbdfaa190d66bff2f44f9d56750b66ab92c8010ae9667d5e46a607d"
    sha256 cellar: :any_skip_relocation, catalina:       "d7c12cd931017e38bb6d0df1210cc244f3c0a47320287cf27c4716ae6a18f195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67fab273352cc1cb6fd43a9eadde3306291114878e4bf3134296aaad599c5f3"
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
