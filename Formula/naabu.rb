class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.4.tar.gz"
  sha256 "2d9f01e42f2182d008041e145c047a7ca45d31214a2d20b1acf4a148659b5815"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c2209fd89c55bb3a1e1e7d9d987606ddacead8c971202c1139fee903fb8ca18"
    sha256 cellar: :any_skip_relocation, big_sur:       "355136b88ffcc0818dee4c87b62f1d3367b6423b44fb30b4971a0953f375a20d"
    sha256 cellar: :any_skip_relocation, catalina:      "2222ec04a10a6c6b7398a91b912f375359876e9dc3331af546aed3cd2e19f5a4"
    sha256 cellar: :any_skip_relocation, mojave:        "c7865a48a22f3aa8685a00671d691f1cfd340e1205688aa784c0d8e3acc5ec37"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
