class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.8.0.tar.gz"
  sha256 "35f8a35fe1048b0ce30c8a9bd97a53b40063e3e5c87e85360fe9cdc363258d9f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c592a4c753771f52dd248eaba401b3a108e07fc07aabc87b0900c5649a8a34ab" => :catalina
    sha256 "0c66b229f9192069dc5cbac020ff95cd181117990cb2037fa5686a9689d02077" => :mojave
    sha256 "4ef807ed5bcfea9eb3beae5408bbecfe91ab76404db094aac12a0b5a512db056" => :high_sierra
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
