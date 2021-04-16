class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v0.0.6.tar.gz"
  sha256 "2dfcca8d6108da9cf03367f8357bed87f76d782f1001049819164e7b50841e6d"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72a5c2b27c8aed320b478eae7eff5690bc88be096b90f718355180b68d825d55"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9ebfe1291a2a6892cf8c785530c2a34e8d7eadb009056e2de85985c2eb63b4a"
    sha256 cellar: :any_skip_relocation, catalina:      "eae3bfeaff3972701fbae550245f0273b406e11d780e7ea53ee744c564062df7"
    sha256 cellar: :any_skip_relocation, mojave:        "1fbaceadcc332f73082af3af29bfb1b03e33a33a72a0320e326e024c1fc6c10b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
