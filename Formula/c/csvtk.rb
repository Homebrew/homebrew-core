class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "0b2ed4c03b6082179b6c0d117a6d8e74d9bf53f334bb15d952fa059f58206d06"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08ed5b1034c0afe10df4afc8b634456b58932d4c1962964f170a032463e23a2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08ed5b1034c0afe10df4afc8b634456b58932d4c1962964f170a032463e23a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08ed5b1034c0afe10df4afc8b634456b58932d4c1962964f170a032463e23a2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ba06d80a231a00b0641e9fad4c6f5296edb00b961640d3e483de13337312367"
    sha256 cellar: :any,                 x86_64_linux:      "755dabd3b62a979440799eb501c2a92bfeb7abda557816bbcc198392e308e452"
  end

  depends_on "go" => :build

  resource "homebrew-testdata", :test do
    url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./csvtk"

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
