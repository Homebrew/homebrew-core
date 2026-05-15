class Mtbl < Formula
  desc "Immutable sorted string table library"
  homepage "https://github.com/farsightsec/mtbl"
  url "https://dl.farsightsecurity.com/dist/mtbl/mtbl-1.7.1.tar.gz"
  sha256 "da2693ea8f9d915a09cdb55815ebd92e84211443b0d5525789d92d57a5381d7b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7546780a577d53570daaea86bd9306fad67197ab4fb869090c43d17bbff88474"
    sha256 cellar: :any,                 arm64_sequoia: "481216ae78025ad4b0e03fe33108dd9a21a82dee2ecb47e301144588bda284fe"
    sha256 cellar: :any,                 arm64_sonoma:  "3983fe83804275dbc3ec23807027c88a1971c7d7eb39b917679985be51213250"
    sha256 cellar: :any,                 sonoma:        "313e1023e84adcb21d608ecc2869e277b52b93a2bc5160a9ce3f9c711d291956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47a8e9c5014ccbcc1cba631fc6b6f6a41bb881b53d6345123dcff7730731100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6088b5d34bc9970ae90f0ca4885e17e4556a678ca44f540cd1ed34b24ed0279"
  end

  head do
    url "https://github.com/farsightsec/mtbl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    pkgshare.install "t/fileset-filter-data/animals-1.mtbl"
  end

  test do
    output = shell_output("#{bin}/mtbl_verify #{pkgshare}/animals-1.mtbl")
    assert_equal "#{pkgshare}/animals-1.mtbl: OK", output.chomp
  end
end
