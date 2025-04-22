class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "f325933dd2e2c4f8b83fac59df1a06b4b5b914c23c23acfa5658b676936dde9f"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de4fd6a17277f4e9a178cab48b5ca6135c304b27fa1617a1b9ea49a3f96260d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4fd6a17277f4e9a178cab48b5ca6135c304b27fa1617a1b9ea49a3f96260d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de4fd6a17277f4e9a178cab48b5ca6135c304b27fa1617a1b9ea49a3f96260d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "20deb9324aeacaf068a1edcf988890e0a1f15ff3b735599513fd028b871fa7ac"
    sha256 cellar: :any_skip_relocation, ventura:       "20deb9324aeacaf068a1edcf988890e0a1f15ff3b735599513fd028b871fa7ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8ae2c10c57b6852b45ada75c178336f36b19e77f292ef25b65517baa8c52805"
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
