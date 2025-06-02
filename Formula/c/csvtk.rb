class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "7cff5c7bc5ab79ec6d57237e72cd0c258712814681e1a9e35ca9f15bfbccfb11"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac1f71c7cd43fdf92ee9c4142af9df200117e097ba4e2c6b14610bd6f1f956e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac1f71c7cd43fdf92ee9c4142af9df200117e097ba4e2c6b14610bd6f1f956e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fac1f71c7cd43fdf92ee9c4142af9df200117e097ba4e2c6b14610bd6f1f956e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8aa4654478d26a028ff613490fa86e603ca73cedcab65d8680b9bef5ac4026d"
    sha256 cellar: :any_skip_relocation, ventura:       "f8aa4654478d26a028ff613490fa86e603ca73cedcab65d8680b9bef5ac4026d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb6c6db444aad11c72af872e744a396562da0d2a27f08456b910354e2f18a2f"
  end

  depends_on "go" => :build

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
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
      sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
    end

    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end
