class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "6f916701875fcb5f00036aeb93b63ac84205241ff23b4250b78ac93381bda2c6"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f651e0b0611dc206903732f7158a557df44ab83a4d93c773683554cbe6992baf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e374d48d545342f695cde7992e0853d1f51865395e7bb411cbb5e86bb3bf45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9721eca44dc940dedfcfa27e5bd72cf65dd4c01af2098a70fc0180305750ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "0400585d5298f0b522de82c1839313526694f8448bfe61ba8cd8581bc5d9ffe7"
    sha256 cellar: :any_skip_relocation, monterey:       "039decfd7d2a476af1032ed179aa33268e970ab11633b7307186cf96e95f1d5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "718ea988a004815f6f772f1c5fbb6ebd468941918ed9a5d347a9d3fe0180dc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07bc7b633fa2cae69c05a506d0775aa41215238a077062caa21626886cc37751"
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
