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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e794c89e70f0060b0e02caf5c439b3f8a2300a55cfd9f923aa3e7616d68b9e8b"
    sha256 cellar: :any,                 arm64_sequoia: "5aff480752ccf8c12530d8cbecd3c11ef804452ff751ddc81e89c093980f6623"
    sha256 cellar: :any,                 arm64_sonoma:  "749bdff8f9a6f7c305241e3a90015230113601e6600150e47ea1fa7d879ccc57"
    sha256 cellar: :any,                 sonoma:        "8b216c4a508c451475740893d10f241c24f7ca5c6b23a78efb753d2f72ac05e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57001fc63b43ce00a3d8c4f02fd7b6d34123752e6684fdfbac73699660497a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c369951fd44567712e4dacb34d20b6a4ad3b729669ddecea0dca256ca74d4cc8"
  end

  depends_on "gperftools"
  depends_on "python@3.14"
  depends_on "wget"

  uses_from_macos "perl"
  uses_from_macos "rsync"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
