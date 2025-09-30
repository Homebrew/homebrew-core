class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "5bbd79392ff7c530124986dfdfe126bf638477db94fb7a901ec2daf9261707f3"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da832fc408a971c58b1b9af2da8e4a47f15380352f8d40fac75d4331d45c40c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b732d36ce47d98141c8d428b132ebec7e8005692321ff2d4cecd2c4cf0039109"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06ca8eba9fab9d0eecb9d9b37ece478ed2c9a54e1163b90f896b6a809002eadc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd7c2282a9bb1ada0f2408901c5af731b581833e48e5e6657337f48dd963c84e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7c71697836584e2c651c7dfc9420b0b72012fcf47c2990097f5f5c7531c50c5"
    sha256 cellar: :any_skip_relocation, ventura:       "4acb1a0a318f21c6a821916580888395bc85839563015db2167fb32785dcfdfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d4ec13898868eadc4008393a1c3d7ef8c3b6bf34ef903a78bafd300de9f2c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca100381d28e5c0780b3cd4f765c895132d187a205a7345a3c6f880ab31cd82"
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
