class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.7.1.tar.gz"
  sha256 "5f112d17ad62f0c6e33d83b7c88c2920e1785cef250b8bbed3e4b068bbc51350"
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
