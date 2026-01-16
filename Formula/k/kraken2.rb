class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.17.1.tar.gz"
  sha256 "4dc64ead045b5ae9180731c260046aa37b6642244be085a9ba9b15db78ab442d"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88c74f5190f608380ef3734d2ea3a919e6c032d4246a77ca88824b3eeb84d497"
    sha256 cellar: :any,                 arm64_sequoia: "1c1a8512713c861ecd871579980f200943a6889ecf7313621e69907de3708b79"
    sha256 cellar: :any,                 arm64_sonoma:  "5c6118db5d37cfacbb54d9d9837d778661da05dc344233e7221c4d6646b0c43b"
    sha256 cellar: :any,                 sonoma:        "fdb2d185543598e8cfc9ba675295f609bace11cbf57fd1cc6f357fe729ce38dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "943cddb18d69c9c93b7adfeacfcd5d319b8dd0821a1ef49dc9761ffa87fcad5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067fe5546cd15caa776ee5ed5cc07372031f81897c6a8ce80cd7cb368929ebf8"
  end

  depends_on "gperftools"
  depends_on "python@3.14"
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
