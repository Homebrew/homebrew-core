class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "d8a14118413df69ea6af4bfb9cf9aad5f1e9a49c3c5359beced9f0800d07cef2"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bbd1d3abb795e1ca5b76ce88ac80e28b2d97b028332df0bd0d0cc88d3341efd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0254d431615aaa189a07e6fffc8cc61582272de81bba113a491389d8a4c42c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a31795a81f4bc5b3a21b7b8b1b391b74cd8182769186454dc8033e483a8b1ec4"
    sha256 cellar: :any_skip_relocation, ventura:        "829dabc7a4181d5c6d7a9ee4197267f301fd7322c5003eb1699c62d66b2bb54e"
    sha256 cellar: :any_skip_relocation, monterey:       "51bad64b99e38c9e20efa880eb2031331c7f4f82a3275cfc8a2df1b84afbc72f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0ee5e5e2019816c7884b4172da767407bb8a26e2734a6f8ad3c9d52de5f654f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2dce7d71e61ace5bdcf96149d5f66693403463c2ef5639db0861147df546320"
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
