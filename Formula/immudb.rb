class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.8.0.tar.gz"
  sha256 "35f8a35fe1048b0ce30c8a9bd97a53b40063e3e5c87e85360fe9cdc363258d9f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfbce54ccbcaf6d248b364617f027f480c8ba433663157fdd9dc3f3df976c341" => :catalina
    sha256 "f8259385cafe85d377618b9eb62487242e4750fd12182aef30a81e6cd0a4ae4f" => :mojave
    sha256 "d1d91c2269d7d53b1c61377a870af664f9f3d93e33eb6de3ecea24b9a1be2705" => :high_sierra
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
