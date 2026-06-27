class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "90068a24f055076d65f54b18fa796b5322ffe728687d972038bb2ffa2ca07be8"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03737f464f387d6be19433b23a320b33957e0b7f49d735b6ba77cbd9afc4fc5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03737f464f387d6be19433b23a320b33957e0b7f49d735b6ba77cbd9afc4fc5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03737f464f387d6be19433b23a320b33957e0b7f49d735b6ba77cbd9afc4fc5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a67196c00647d0a8cd5a05f00b1e2dd9a8dadb28817dbe576b4c650d9d2d2138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b69c4220ad86ce46589b60a57bf75466ffdcb239fe8d6d61a0b285838c4201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed61dd44e04e3482df624a064e18d4b32cb25c6349d76682d7f66135775def81"
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
