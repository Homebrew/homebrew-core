class Kraken2 < Formula
  desc "Taxonomic sequence classification system"
  homepage "https://github.com/DerrickWood/kraken2"
  url "https://github.com/DerrickWood/kraken2/archive/refs/tags/v2.17.tar.gz"
  sha256 "69380e7c22e314245cbe61b2a69d6719c95edadd80ad171577c1e681927c7b88"
  license "MIT"
  head "https://github.com/DerrickWood/kraken2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a9b36a4e1c0518548dac55c1fc4f626d988d0953de1c835f908dbf03f6852c2"
    sha256 cellar: :any,                 arm64_sequoia: "81e7b1df656d2dfa1b2c0ef7a3560593ef8fa052318bfe48b231f92e2afddc1b"
    sha256 cellar: :any,                 arm64_sonoma:  "062410e12c20c360f3d33b20c053f04e3b5107d403558cb2bd07890148466628"
    sha256 cellar: :any,                 sonoma:        "cdf3421d74de8aa109bcf6154ccc2024f6a2c4be154c8e7c8bd62b5b413b6d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ec19f54d8e318a1db01a18088b8fdce79c3ad09920d9c75bbd8d470d7ec3a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe5f8af43ae494cc9dde963c72ff860ea45cbd447e570b3f426e2a3c0dd61ef"
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
    # Skip `libtax` installation, issue ref: https://github.com/DerrickWood/kraken2/issues/993
    inreplace "src/Makefile", /^(PROGS\s+=\s+.*)\slibtax$/, "\\1"

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
