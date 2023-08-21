class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "d7a1ad5ba964bf97a69e99812c6a28c464f42594a84a61feea1ce2c09444e87d"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335172e56c780a88d998e2f0cf115820138f4398e1e1421b5d98a38c8107ae22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16ba942bb456b463c4ace362154a99f4df0a7540720b8fb108cc4b928840356a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bac248a654de83a2f10e696fe6de52aff456fff24b20eeeb875ce8a3c5fd957"
    sha256 cellar: :any_skip_relocation, ventura:        "8112f482f45f0aae157cdd6a6cf131716beac970df852ef0e2d0d01c675925f8"
    sha256 cellar: :any_skip_relocation, monterey:       "5078f6db6d8a976bb8f3638487e9318c85b05e4a80a6530d055206b4f378270b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1139ce2913c8c4536591ac5fd5734ad1d8396b710f1c8879342a813882515a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "376099416f8c6efb7583c02fca4c98bfb948c285e39fe4cfce673c53d99726a9"
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
