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
    rebuild 1
    sha256 "fd2d3440238a957e684c4799e1024e7f22efa82bb90ac772ae2eb3587bfbbe46" => :big_sur
    sha256 "e91a080299ec7b6414f3d8f12cffc4349bd5239b0716edf3d21623bfe86a68c1" => :arm64_big_sur
    sha256 "b033a1e612a61dea608528086e71a43071648be7d58a60d74b64d05f91859cbf" => :catalina
    sha256 "69f2b95ccaa655900d8af3ea00f2c59a0459dc0d59244d186c2018ea51e08801" => :mojave
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
