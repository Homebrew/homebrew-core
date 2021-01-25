class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.9.0.tar.gz"
  sha256 "28c2ea31eaac4401c4b92290d4d3e16ac7c196aaed1aa065d71b211d306ed398"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5f67d609e5ef9723a80719d36ad0893d282cfa1788d7e145945bfe52f34ce271" => :big_sur
    sha256 "67fbddb2bb4c218f87ae0ab0f3d13d97b59b726674edea63227b3cf5cbab7db2" => :arm64_big_sur
    sha256 "e6c40015f44470c6a2845f67f267e2f61c5a0ca67423178edb7df150d175aaf0" => :catalina
    sha256 "6d9b56699399cea98af56a35e376262b223f264a2c04fe7e7a8b05eeda043d59" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  test do
    immudb_port = free_port

    fork do
      exec bin/"immudb", "--auth=false", "-p", immudb_port.to_s
    end
    sleep 3

    system bin/"immuclient", "safeset", "hello", "world", "-p", immudb_port.to_s
    assert_match "world", shell_output("#{bin}/immuclient safeget hello -p #{immudb_port}")

    assert_match "OK", shell_output("#{bin}/immuadmin status -p #{immudb_port}")
  end
end
