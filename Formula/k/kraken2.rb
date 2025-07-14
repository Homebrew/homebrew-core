class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "6feb9b1e0840a574598b84a3134a25622e5528ac6d0f4c756cdab629275d8f42"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee275caf279a788ea6a7bce93190ab31165bbdc79fd1dc812ba120336a1918f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb22cec35e13ee86ec66e1f65f90a4b6454e418da5df13bf786e48a1dc846e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a875a1a58dde84ca8651102d3e99fb1eb0ff2c1089fc5fc4587e56f0ac0ece33"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e6e9db41f330e526dcdaa1061c530ecfc351f1f89004ce69695b480fffc195"
    sha256 cellar: :any_skip_relocation, ventura:       "43e3bb6870bb0d9cf4d5a9d09bc8850939922acca99ccfa56a84c9f77d9a3162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5490c61e588570bfbab8976c233dcf75d57ffe3113bfa800d6e8470f298b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ca42ce0aa2688d8ca4f9bb123ab1cf372a79e8944f511312a26b9da4ead3927"
  end

  depends_on "python@3.13"
  depends_on "wget"

  uses_from_macos "perl"
  uses_from_macos "rsync"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "./install_kraken2.sh", libexec
    %w[k2 kraken2 kraken2-build kraken2-inspect].each do |f|
      bin.install_symlink libexec/f
    end
    pkgshare.install "data"
  end

  test do
    cp pkgshare/"data/Lambda.fa", testpath
    system bin/"kraken2-build", "--add-to-library", "Lambda.fa", "--db", "testdb"
    assert_path_exists "testdb"
  end
end
