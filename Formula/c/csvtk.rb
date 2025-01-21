class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "eb54e0a14207b6c58cefd9bc6747453e758b2bdbf8e111df9873628b6fa23a01"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8db0ae4be89bbbaefea6417c7a3b12ec6929ba7cb12365dd08051f480b34eff5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8db0ae4be89bbbaefea6417c7a3b12ec6929ba7cb12365dd08051f480b34eff5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8db0ae4be89bbbaefea6417c7a3b12ec6929ba7cb12365dd08051f480b34eff5"
    sha256 cellar: :any_skip_relocation, sonoma:        "15bcfc71ae3a91b8b443b9664f0566c45ece817a200d22d9600ed5e335bb8ce3"
    sha256 cellar: :any_skip_relocation, ventura:       "15bcfc71ae3a91b8b443b9664f0566c45ece817a200d22d9600ed5e335bb8ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c8f4630124c34553387e7a4afc52d0c0edface8cdeeca73614340dba27725e3"
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
