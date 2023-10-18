class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "e1017ac0da20e058efd0445fe889ee9d7b91b56a13e68379fe3035b218ae79dc"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b013e3abad9c11ee3da6c055e208e7df0f9d1ecc6995d84183e00cec069c0364"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bda4d2f37af34cd86c46bc20936680b58ef2a6a9f79790c7e7694dba9aa73624"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "942b325e864334ce75516899c33fd9f423d2034fbdc878a39d355aad56af8c7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6be6ee0e1849f26f204a12418f114a08149d1a0adfe4215c66eec0611caec728"
    sha256 cellar: :any_skip_relocation, sonoma:         "343f81559c6ac68edf4078b669a86f340f9e92ae3190addaf487c56c1e6d0004"
    sha256 cellar: :any_skip_relocation, ventura:        "7421e6efc0999e1d2738bf31b1ee537401a35b34cde583f9de37a1aebcd406ee"
    sha256 cellar: :any_skip_relocation, monterey:       "dd08c584ec7198768c9ff05ae6ffddb912a5823aa0b412116bb745125008e70c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bdbb8583fecb3b0c0788d66d489ecb92e48f6cba6464d9b9de21fe79e4104ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c83aab3ecca4d38786c786887b2a2e47bf06f9095486ca91676244c44770ba0f"
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
