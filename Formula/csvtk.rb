class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "47d244068274ad5070ef50cafee243d1035c51692b025bf074d0b7be3f8a7d1c"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e724f8e7d696f4a9000218eb26fd47e630807fa8c1bf028b0c355f063da092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b57e9972d8444d3efcacbab3d8fb0bb105cb4e748dc615aea4bc69a441e5310"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1f2d2c2dcb4da27cf0a7a455632ffdbeb1bf60d58119b7ec993d6e18881d7d9"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd54c4a0ecabe5323173f3f9c2c93a246baced3edc248a28febf1c7ed4d9ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb590cb449bd0bd7a87a93f4557dee620a4773fe3a5870163bc1ab8aaff7e55"
    sha256 cellar: :any_skip_relocation, big_sur:        "997ab37d15bc89e995db26128be9de166766b5af8e71105b122053cd09f7a540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82e21b95073094055c192a0b53a18d6bd6e3b3dea77fad39ea6b96c66aac72a"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./csvtk"
    generate_completions_from_executable(bin/"csvtk", "genautocomplete", shell_parameter_format: :arg)
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end
