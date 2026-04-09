class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/mighty-gerbils/gerbil/releases/download/v0.18.1/gerbil-v0.18.1.tar.gz"
  sha256 "e1827bb88bdb74a01a99f0d94a50a6469ae4e760905be83dd3064ffc1709ceb5"
  license any_of: ["LGPL-2.1-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6745d8bce39a3b89bbf4b5c3c69cac16ada9073a9a8216ebba04507b63f298c3"
    sha256 arm64_sequoia: "d42dd1a6b7f7b922eae3a3f9d3d51ff97893d4fb93ad98ba919381d4dddf3717"
    sha256 arm64_sonoma:  "4e67eee05dd06c0e744af6e715ffdebe003f3f3d207de6f5805c75d27dc95a20"
    sha256 sonoma:        "e1c3c27f77b53389a64aa3c46179877217f8b1b411dec0de2940e57cc1efab07"
    sha256 arm64_linux:   "28192cc2a3d65cd154d33e86b8d4c341cd487fc32aa62762238285d34e2899bc"
    sha256 x86_64_linux:  "ead102fa71b688c6923afa46460741d75848aa18c13f521854358f545ae8d6a7"
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
