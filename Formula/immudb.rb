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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d7295fb6bc0fb6689146d454dfa9ad7856b9a388746a48bdbfdc1fa17dc9c97"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1b67665e3b063f375151def8fc27e652761c915573cb1b5c121db3d093ba38a"
    sha256 cellar: :any_skip_relocation, catalina:      "21b6ea017ac562e0aa3c5169449c9802e8671cc0de7d5a63c045fd6254c7d1d5"
    sha256 cellar: :any_skip_relocation, mojave:        "5362276aa69423fb456d37df1da348bb388dd9898ae63a8d660f7ca870d65fd9"
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
