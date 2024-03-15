class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "dd4259cdea26bcf9d835985215edd2c1e6f48dab042bec6a196fe1469a595c7e"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00464fe0a321d715d654899f53896e9e4285bc717197608bc266e22fbea4a686"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa9cc1585adae1f80f06f209348e850f7386c0543b7e556f1152c7795528d5d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2cf399247cf8086e70636aa059e646584c53eab89493fecb8a4d6d5e16abaf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d90515fc92bd295da614a9d0c060d3e07c8448266a9245946e0aad43555d8030"
    sha256 cellar: :any_skip_relocation, ventura:        "14af51267e7054bad1397055ac22932bad06036e84e59055bf828fa809c1dad8"
    sha256 cellar: :any_skip_relocation, monterey:       "3b6efb641c209e8c8622b55fc45870febde57dc162ffebe1124cdf308603618d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e3347e913cf65d644ead17a3cfdb736f0b0e6c551d5d96c4f91a5540d3696c"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./csvtk"

    # We do this because the command to generate completions doesn't print them
    # to stdout and only writes them to a file
    system bin/"csvtk", "genautocomplete", "--shell", "bash", "--file", "csvtk.bash"
    system bin/"csvtk", "genautocomplete", "--shell", "zsh", "--file", "_csvtk"
    system bin/"csvtk", "genautocomplete", "--shell", "fish", "--file", "csvtk.fish"
    bash_completion.install "csvtk.bash" => "csvtk"
    zsh_completion.install "_csvtk"
    fish_completion.install "csvtk.fish"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end
