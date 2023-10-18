class Mtbl < Formula
  desc "Immutable sorted string table library"
  homepage "https://github.com/farsightsec/mtbl"
  url "https://dl.farsightsecurity.com/dist/mtbl/mtbl-1.5.1.tar.gz"
  sha256 "2e2055d2a2a776cc723ad9e9ba4b781b783a29616c37968b724e657987b8763b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f3ad7ea28ca47d37fe5d937fff2bd15fe8936e1d0e1950753b8fa516dd9181e"
    sha256 cellar: :any,                 arm64_ventura:  "e02194db1f9ef963735cb575efe5951ad893b8c30bee6d73b50ee8965ca9d87f"
    sha256 cellar: :any,                 arm64_monterey: "e2cf79aa153386e9ed772df5223e235af08fd45aef8be820493e62954417f37a"
    sha256 cellar: :any,                 arm64_big_sur:  "c61ab094b68cfe432563fbfe322b29703dbdabbfdcba4635ebcc7b706a0d2e59"
    sha256 cellar: :any,                 sonoma:         "022f3195ff8a16a911a100bbd4adfead3832453da906fd963efb995f92087ffb"
    sha256 cellar: :any,                 ventura:        "37112cadb47292fb89d739cf5909382d3562951ed8ce175a1d6430f67c8fe3cd"
    sha256 cellar: :any,                 monterey:       "5dc58c7014a5f07293e53b4adf53b76d43f83b20464b039cb6c43673c591da04"
    sha256 cellar: :any,                 big_sur:        "5e44a0eded743f0e9d1126df36995745e31d10cc4512ebaff0714accad2c4d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba00c246994dd7cfcbfbddd9d7e9c439bbca98d6a1c2cf7748e59d9150c0d07"
  end

  head do
    url "https://github.com/farsightsec/mtbl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    pkgshare.install "t/fileset-filter-data/animals-1.mtbl"
  end

  test do
    output = shell_output(bin/"mtbl_verify #{pkgshare}/animals-1.mtbl")
    assert_equal "#{pkgshare}/animals-1.mtbl: OK", output.chomp
  end
end
