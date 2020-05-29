class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.6.0.tar.gz"
  sha256 "2bed8d984767c970b8e0dc15a89db5737e909b3052489debd8db47c9ea3906ec"

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
