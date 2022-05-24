class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d944e55d9555733990783bbe45200da5eaef47a13d4eac242ef084d9384d54f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d48edb96cf9e1554aea914c9867201729c5ea014d800ca9ba197b793851de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b2f09bb13dc00622c012dfecb1705ee11d1bd2e1ab1a818448aef464876961b"
    sha256 cellar: :any_skip_relocation, monterey:       "d6c3adf4c7016b4a3b21556045d5539ce3cbc34a1540fe90badd9797adb717b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "38d46efee033ef17d39fd5e93a0a96cfda0c0ca39a69f3bcb2dbbaf154dc91cc"
    sha256 cellar: :any_skip_relocation, catalina:       "acea84dd2a22b036bc5e7445e7ddedc2e5dfdeaeac3c42da659c8e171362e36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087a5bb6bfcae4ee7278be49e2cb0eddc117878c2393ddf6e11a1c525d043914"
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
