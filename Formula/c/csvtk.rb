class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "0acea7e49c8af12ed76b11ec562ffc05a2fff28cb3c4e7b032e9271f13599ec8"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad7140284f50c7162411d3da82294310ba3b71ebdff1ae51f0bc83d226926ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7140284f50c7162411d3da82294310ba3b71ebdff1ae51f0bc83d226926ecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad7140284f50c7162411d3da82294310ba3b71ebdff1ae51f0bc83d226926ecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc8ea12b20cc1343ad55624d92e6ae46b7cf7b22ffff7a9de0f182921d7fbf4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1622f170405baee419688471af0c614adcf93568eafd01c8b6cff8023996d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5d28484a4235003436d010c24dc7237f8b6fd60e5e5dc900c9f63906b57537"
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
