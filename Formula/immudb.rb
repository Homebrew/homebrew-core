class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v1.0.5.tar.gz"
  sha256 "d30bf02c111b8a4f99475ea72339f1f04e3df95eb5ce53103e0a26dcdfe1f24f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1948979691ff59c3451a8b4059f8ee46260ceb495bd6160457addf1ac488d2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a790db21667de3c27adf5907d0a6791862cf6d25c4534d71b48057904227e1f6"
    sha256 cellar: :any_skip_relocation, catalina:      "8ed8ca363acf0d35b43a274908989e1605c3d21dc9ee956e4dae86fdb049b2d8"
    sha256 cellar: :any_skip_relocation, mojave:        "5bf7ea3fbf0681e276ddee03ce356417f3d3b566c569721343bc500ec3643156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "572f21705837f49ea3bf2bbd41b94b3ef4b0ef5cc49d0c0a21bd9558dd4a8e13"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    bin.install %w[immudb immuclient immuadmin]
  end

  test do
    port = free_port

    fork do
      exec bin/"immudb", "--auth=true", "-p", port.to_s
    end
    sleep 3

    system bin/"immuclient", "login", "--tokenfile=./tkn", "--username=immudb", "--password=immudb", "-p", port.to_s
    system bin/"immuclient", "--tokenfile=./tkn", "safeset", "hello", "world", "-p", port.to_s
    assert_match "world", shell_output("#{bin}/immuclient --tokenfile=./tkn safeget hello -p #{port}")

    assert_match "OK", shell_output("#{bin}/immuadmin status -p #{port}")
  end
end
