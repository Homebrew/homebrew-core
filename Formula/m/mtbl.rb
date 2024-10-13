class Mtbl < Formula
  desc "Immutable sorted string table library"
  homepage "https://github.com/farsightsec/mtbl"
  url "https://dl.farsightsecurity.com/dist/mtbl/mtbl-1.6.1.tar.gz"
  sha256 "bf2711aa81a996cddf99f270cc7cb1c32dbed7f1bfc95e23ec6227e4bd08365d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "97317e41371a31ef89d654600743ffc15294f36629f1d21800b641588d9491a5"
    sha256 cellar: :any,                 arm64_sonoma:   "8abec69768a50d89975e04072e3e546453ecd2f1c3271f645769ab4b23a9aa58"
    sha256 cellar: :any,                 arm64_ventura:  "3e16710be45c82ca1ca31d823f426e5b07959b2f9e0c186a6f696100fead851b"
    sha256 cellar: :any,                 arm64_monterey: "3f35f8a96d4ebb6473f3961c040815b881a47bc6c62404147dbc2a39c601f362"
    sha256 cellar: :any,                 sonoma:         "5db2ff6ea378e07fdbd774dd921d4ac381520594d41be21b1582dbbc4b836ace"
    sha256 cellar: :any,                 ventura:        "b3dcf394a52c3c61b44d0d64f222cb6b97ea84bb60b3360b011b38293d782a17"
    sha256 cellar: :any,                 monterey:       "b1dc6d9dd474ba23598bd51a5e2144f0ceae07d3eb79ece4c2e310bb02866602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532d7f6bddb7a756fa3413224c56c6e20094df7f16bcd1700cd34ba959996f9a"
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
