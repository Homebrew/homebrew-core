class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.6.1.tar.gz"
  sha256 "313f09b82f89208705daaf0be16238e1a4f90e590edd038c1719d181ce0ed653"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "769e04db2fd4329c20b6c0a608a3929f774b380071bac36e98a0416457077276" => :catalina
    sha256 "de2a723ef1e42c3b4757951280bc74d8af0d615221fd9513fd423d48c33c29b0" => :mojave
    sha256 "0594c1e0fb1a8dafaf8f8b06f768c3626704260d07a328891a72c2db59834887" => :high_sierra
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
