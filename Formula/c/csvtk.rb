class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "dd4259cdea26bcf9d835985215edd2c1e6f48dab042bec6a196fe1469a595c7e"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3bafd1621df57d414ad5d6391a19800fae7fcd95c62d9a6902f92078e9753bed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b43887e688ec606951fecdc519abae5d7617282aea8ce9cdf984cca100607dfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d684b80250b470ee9518778231341cbbeec148d466af933b285678ed0241a910"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d34048a37bbb9a8df3eed7ec71b4939223fcea2dd8393a90d78b8151ae0f018"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbc4658e7384964209632e4604474056753cd5f35bdd2366e78316fa21ed2709"
    sha256 cellar: :any_skip_relocation, ventura:        "991e2e210c6654973b2bc5a8cca70fa7847ad608314aa5899189d0912f20b8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe09f84544b99d751593be4c0d8ba663feba9974bd13acc6370a928103d9f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b28bb34d7f76916f0053638ff72576b70ea4ef6ee58a4a076ea05b50192fcbc"
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
