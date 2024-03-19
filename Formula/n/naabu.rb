class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "68ffa93f768823a992c602f58ead6018ef1d930eefc5254a2b7ad536f926d0f1"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e09dbccead3229f8110a99ac8f79fb1ad677de114c14c5078e4f23db4fb19e6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6083f348dedb33e5f8f1707a82de064815378e6d506391d47de6b06db1265c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b429704c4dc9aa047dba64444f1f518ec9ac707b368a56079e5016b423876420"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcf7743ce664481a3dde3db30b5561ecdf819eebd4c0c00c79c7a69f8ff152b2"
    sha256 cellar: :any_skip_relocation, ventura:        "45323070d0a4b121a8513406ada5b0b999fa7e19df7633e413fc3e389b057e09"
    sha256 cellar: :any_skip_relocation, monterey:       "651c73186dcd469fdb49ddc06e7fe5901ac0e0a6075bd6c86b476e80bd03adcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bac5d06e4a4a3d0456ee5a5b9c7fefdb78ff8ffb2b90eeb8addaf08849215e2"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
