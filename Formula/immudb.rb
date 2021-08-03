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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "acffff44c6eb18696beadd860ed49372b774b71a001e000769814c0b5655d49b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ae67b0f6e11f4e3b3eb11c1b0a71a11d5ac23567d2317294cf4cc77f94e5379"
    sha256 cellar: :any_skip_relocation, catalina:      "56e5eb3bc43fd14f2f185fa5ce64b0af0602d9486a64a9833c82339a521ba12d"
    sha256 cellar: :any_skip_relocation, mojave:        "11735f30c14e7d07d6ec0cbebc2d958f87a95b3b0ac3580bd14353453f1c4ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52214840301ffdf1151ae07f966ff9be075049dab1adbc3eba1d4393b634305c"
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
