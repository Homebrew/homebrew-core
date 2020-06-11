class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.6.1.tar.gz"
  sha256 "313f09b82f89208705daaf0be16238e1a4f90e590edd038c1719d181ce0ed653"

  bottle do
    cellar :any_skip_relocation
    sha256 "846f1978ea3a1cbe033bfb6348e0928bff997f00477b2f17b70c1bdcb8e31b58" => :catalina
    sha256 "d23f02317c490e9c2cb8cc197e12158f4c62234a2444632bf134b7536f15db55" => :mojave
    sha256 "418cd7b6e40299176b0659fe8dc81bc12226ada04b315ed07d011eb5a657ab48" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immugw immuadmin]
  end

  test do
    immudb_port = free_port
    fork do
      exec bin/"immudb", "-p", immudb_port.to_s
    end
    sleep 3

    immugw_port = free_port
    fork do
      exec bin/"immugw", "-p", immugw_port.to_s, "-j", immudb_port.to_s
    end
    sleep 3

    system bin/"immuclient", "safeset", "hello", "world", "-p", immudb_port.to_s
    assert_match "world", shell_output("#{bin}/immuclient safeget hello -p #{immudb_port}")

    command = %W[
      curl -s -XPOST -d '#{JSON.generate({ "key" => Base64.encode64("hello") })}'
      http://localhost:#{immugw_port}/v1/immurestproxy/item/safe/get
    ]
    response = shell_output(command.join(" "))
    assert_equal "world", Base64.decode64(JSON.parse(response)["value"])

    assert_match "Uptime", shell_output("#{bin}/immuadmin stats -t -p #{immudb_port}")
  end
end
