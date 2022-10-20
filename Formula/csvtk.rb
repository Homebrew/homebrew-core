class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "47d244068274ad5070ef50cafee243d1035c51692b025bf074d0b7be3f8a7d1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434cd3b6895fdf38adfe0cf83420e8b46f916e2bf18ae1749fea0306d24edebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5a305858fdfc9ca7d36275ffb6906a615df52f9df207efd5b6d67fe78ef9f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "418c568216b92cda592b6971effa8c50e78298030e6f21ce76495b52b167bea5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3bd98413d7c2642508d32420afd9448a4817e611e8a97ec2cd96694cd1daaab"
    sha256 cellar: :any_skip_relocation, catalina:       "70e4f39b714164b44c3e5b55554d78d454db9fcfb185f1f28536aaa1e99f2486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4630f21fe4e10dfbf6b029930822c1be479b010d8a059a1bd0f6c76ae61d1883"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./csvtk"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end
