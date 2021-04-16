class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https://www.codenotary.io"
  url "https://github.com/codenotary/immudb/archive/v0.9.2.tar.gz"
  sha256 "9b50eb1d79e6d2f1f0aa0a11298d7f4a1b767a4c5e8717de9f96d49872d190db"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dfc7de40c10a03df02696f5bf7772681f596b4b3ae2f9d751fecb2d1aea84d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb4d3f0eec18d8e134be2b19fbe53f05fb7b1e95ebec985c67a16c3db6ad0426"
    sha256 cellar: :any_skip_relocation, catalina:      "a565f456efcc0ffe09bd376006f7484fa3c99dc36f199d1a8a7f87211b9e0534"
    sha256 cellar: :any_skip_relocation, mojave:        "aea6f08192f986e61ac105cd1a6b7ca142e1b32dc5002ee33251d7c42daf15bb"
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
