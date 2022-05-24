class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.17.tar.gz"
  sha256 "1e81265aba7e9022432649eb26b2e5c85a2bb631a315e4fa840b14cf336b2483"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/vyzo/gerbil.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "95f3dddf6cf1fc48589aa31fea8b1932337a6d16f3b920fff372f8741c2be89e"
    sha256 arm64_big_sur:  "d5156015ff7c5806db8b89dc05886fcffb19f6ab2b61d9173895ac185bde13a3"
    sha256 monterey:       "83792d7b1a1339a73e36493f4201ab2b1657d2d1f061fb1f0cf50587722448da"
    sha256 big_sur:        "e49f094f25ebc88a787be33c109308decee3aebaf58298f43d429a31cbaa53d5"
    sha256 catalina:       "c136d9ffbf63bb1ac05c9b5c4936d61d97e855fc90964163ea645e32e9adeffb"
    sha256 x86_64_linux:   "6b0d5524324abcd1838483696a9e04e21cce47d7a0910e2ab20a48940454b09e"
  end

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    cd "src" do
      ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
      system "./configure", "--prefix=#{prefix}",
                            "--with-gambit=#{Formula["gambit-scheme"].opt_prefix}/current",
                            "--enable-leveldb",
                            "--enable-libxml",
                            "--enable-libyaml",
                            "--enable-lmdb"
      system "./build.sh"
      system "./install"

      mv "#{share}/emacs/site-lisp/gerbil", "#{share}/emacs/site-lisp/gerbil-scheme"
    end
  end

  test do
    assert_equal "0123456789", shell_output("gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
