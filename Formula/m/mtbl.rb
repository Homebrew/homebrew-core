class Mtbl < Formula
  desc "Immutable sorted string table library"
  homepage "https://github.com/farsightsec/mtbl"
  url "https://dl.farsightsecurity.com/dist/mtbl/mtbl-1.6.0.tar.gz"
  sha256 "6563ddf1c7d9973efa7c58033fd339e68e19be69a234fa5a25448871704942df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03f3ca58c119cc88d591e8d11587ab12bc3dbcbb23f9d8082c3adef37d475358"
    sha256 cellar: :any,                 arm64_ventura:  "c4dde6b7eab863ffe58466fdba3aadc7106d16a08e125ce87458dd2ff2661e40"
    sha256 cellar: :any,                 arm64_monterey: "70f42be92172d7bf4738fec0cea2e573c4773d80a4073f4770f55dbcf49e7eea"
    sha256 cellar: :any,                 sonoma:         "b2ecae34cc1ed730dac39d4f12bfee6a86975f60d684d19cf11b1f398a596199"
    sha256 cellar: :any,                 ventura:        "8ccf01e6e6f489583c5fe4dd889f2464d001814c6d4b1bdc96287e7802ed6977"
    sha256 cellar: :any,                 monterey:       "1e6081e3b7eb166038c66a1100a0bb9885d7ecc649b90514afe394517984b49b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad29fcbf4278dc3d0463b9b41f5d3a83cd2648cfd76f837f7cd90ae52f0631f7"
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
