class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/mighty-gerbils/gerbil/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "8e4cdefea8d75feea4d5df33cc90b37dc5e8d6ab03b7b4b7eb749ae7d9ff739e"
  license any_of: ["LGPL-2.1-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5d5b0c0983acb6e54a5b980bafd5966d0a56a565ad5629a70f6664652cfab2b5"
    sha256 arm64_sequoia: "d0d981ad80f1b71ffe7ef8fff4b6e5f5e330bb348ed82415d1d536ae6d387f27"
    sha256 arm64_sonoma:  "32a553ff944193e9152d3e164380e484d19d4ef71232e292a62c1515c90673e7"
    sha256 sonoma:        "5004a6b5a26614f190c4fc4e5d3e353cbb35b4f56c01498a7d278a6494f065b0"
    sha256 arm64_linux:   "b329cfd3d24ed07d56b6a6558e051f970083f29c02b43689db0b575d6077a376"
    sha256 x86_64_linux:  "9e1c6732baed62c845e8fe0169f5e3eb5998773fd12aaa3700a47c1d21fe6403"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "gcc"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ghostscript", because: "both install `gsc` binary"
  conflicts_with "gambit-scheme", because: "both install `gsc` binary"

  fails_with :clang do
    cause "gambit-scheme is built with GCC"
  end

  def install
    ENV["GERBIL_VERSION"] = "v#{version}"
    system "./configure", "--prefix=#{prefix}", "--enable-march="
    ENV.deparallelize
    system "make"
    system "make", "install"

    # `make install` command creates a directory `v#{version}` with `bin`, `include`, `lib`, and other directories
    # then in creates symlinks in root prefix directory

    # 1. Remove all symlinks
    %w[bin current include lib share src].each do |symlink|
      rm prefix/symlink
    end

    # 2. Install files manually
    bin.install (prefix/"v#{version}/bin").children
    include.install (prefix/"v#{version}/include").children
    elisp.install (prefix/"v#{version}/share/emacs/site-lisp").children

    # Install libraries as symlink because binaries are already linked to
    # $HOMEBREW_PREFIX/Cellar/gerbil-scheme/<version>/v<version>/lib/<lib>
    lib.install_symlink (prefix/"v#{version}/lib").children
  end

  test do
    assert_equal "0123456789", shell_output("#{bin}/gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
