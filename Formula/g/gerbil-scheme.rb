class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil.git",
      tag:      "v0.18.1",
      revision: "23c30a6062cd7e63f9d85300ce01585bb9035d2d"
  license any_of: ["LGPL-2.1-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "6c166d32e62d375fab7baf018d875b4f0a44536b9e33158bf9894af87b8964d7"
    sha256 arm64_sequoia: "939444b532cbb429e5385d5b9eaf5c998e5100cd6f44c73a08e03d81cf5390d6"
    sha256 arm64_sonoma:  "f82c1f9904a538503b8465a690f2eeb492b719a76fc0e581610ff46ab10fba98"
    sha256 arm64_ventura: "3a84f0abe9b30ccbbcfc7e5915f75af455b45b53b032f92e3bccae0fe3cf59bb"
    sha256 sonoma:        "4b5ad778a0eb69040087799891cef2915423e36bee59b44b429846ac750a6b50"
    sha256 ventura:       "333d0738fe5d912401ccee0cc0958db84b4e90e304c0365805580d071fb45b95"
    sha256 arm64_linux:   "4d104632dda501548237d32ba5a454dccb9409b3b58b380f39a552017349193d"
    sha256 x86_64_linux:  "6b5f1a9d1e67afb310f18b033089eafa83514b33a9a32605651ff3ddbc5765e8"
  end

  depends_on "coreutils" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc"
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
