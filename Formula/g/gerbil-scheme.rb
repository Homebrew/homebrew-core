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
    rebuild 1
    sha256 arm64_golden_gate: "645a7be1ea6315305ced4c9ace7649cf4434769aabfb48c8829db6a7848ea67f"
    sha256 arm64_tahoe:       "9f0e9f0c40582159ad09a24edb9c6f7c77356081a14b6faad6471fdaff4f23c2"
    sha256 arm64_sequoia:     "42b0fcf59dd86f661c824bab9fdc4cc0a6219c605f3dd5a96f6ba0d34147969b"
    sha256 arm64_linux:       "163e1f4377da81f57b4286d575318e543b2b9f96d0808839d793e62f157c933f"
    sha256 x86_64_linux:      "c5fdfb594b38294206186b90cf5d9bab89359386cdf30dcf0ec8df37de4c957e"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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

  deny_network_access!

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
