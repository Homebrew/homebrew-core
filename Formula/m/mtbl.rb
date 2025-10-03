class Mtbl < Formula
  desc "Immutable sorted string table library"
  homepage "https://github.com/farsightsec/mtbl"
  url "https://dl.farsightsecurity.com/dist/mtbl/mtbl-1.7.1.tar.gz"
  sha256 "da2693ea8f9d915a09cdb55815ebd92e84211443b0d5525789d92d57a5381d7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d99aa92632fd6ead895d811adaae316e95c7db7c3fc9125dc39010f4193435c2"
    sha256 cellar: :any,                 arm64_sequoia: "2b6fa4c8ee0748b475c8de603bc8ad4445e0a611f559efcabb8f32d01570cd95"
    sha256 cellar: :any,                 arm64_sonoma:  "2ac95c6c0d71f51e76820c71fe4a154a8a817cbe7481724845385334a29d0488"
    sha256 cellar: :any,                 arm64_ventura: "4e8b43423cd8c82ef0f2d586b53c9e4ee38e9977e4a4b0b0bbbb5efc869b4119"
    sha256 cellar: :any,                 sonoma:        "32ecbed59f4c384f6b83fa4747e57676915aef4046dca8e71e3ed8ea45acfb20"
    sha256 cellar: :any,                 ventura:       "751ce48fd18ed2f366e62f792819fd4807f90582ba99f4f844585c1d30782710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964ac6e3d6a03c6a037a797a66fabea64638a2c073c412c75cf5cb2afe189cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22aa2d09aa22c71d7646d7d15fd1e8bba3344967f0ebb0c53bbc8dd05c503ea"
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

  uses_from_macos "zlib"

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
