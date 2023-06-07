class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "47d244068274ad5070ef50cafee243d1035c51692b025bf074d0b7be3f8a7d1c"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f9d3ea6a8e49e2fa8be00d46418af4deb5d4ba9395954675662ea0b5e2d4ee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490f17276b7b77a93b26bb709a56c0f64d95947d77a4309f71231f24734edb58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d568f0bc6d7a6f18df3888badf3a3e8456aa7693738a1d72724c10aad392aab7"
    sha256 cellar: :any_skip_relocation, ventura:        "932009d51c1a2e1c574581fd132e70c3ba3ac388ac416ea96e05c89315b43635"
    sha256 cellar: :any_skip_relocation, monterey:       "b034f01cbbd94e5f6ebe1b31a0c71ecdec4e65b728a33662c5033945c5564157"
    sha256 cellar: :any_skip_relocation, big_sur:        "d63ab9cf3cbb6cb5fc5f47a3136c75dce4070fd8aa69041754b31d4352a7595d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6303c9b3ebd9a3091b8d1af45d24ad61b4e462be56000de66c3e30dd3b54dd6"
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
