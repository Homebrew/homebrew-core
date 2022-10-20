class Ldapvi < Formula
  desc "Update LDAP entries with a text editor"
  homepage "http://www.lichteblau.com/ldapvi/"
  url "http://www.lichteblau.com/download/ldapvi-1.7.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/l/ldapvi/ldapvi_1.7.orig.tar.gz"
  sha256 "6f62e92d20ff2ac0d06125024a914b8622e5b8a0a0c2d390bf3e7990cbd2e153"
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url :homepage
    regex(/href=.*?ldapvi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "36ca8c1e3ed87aebd980c3b188104f74120756d6719eec55ec6376cc622717c4"
    sha256 cellar: :any,                 arm64_big_sur:  "321c4e8a2ca63fd24cd5a5f719e989296df2be64df6afd65ab6c995af77681ca"
    sha256 cellar: :any,                 monterey:       "63c5ade32f9583ee28609efbcb7109a37c4e39ab4a28ab970644f6b619800bdc"
    sha256 cellar: :any,                 big_sur:        "be1aaa9c7dcef2c7f65552c6668c4837cbe645503bf75c552dafc11eb1daf8ed"
    sha256 cellar: :any,                 catalina:       "39eb0b3f2a5438046de3f5722a65fcf8f386f317c051afe944a61dea359600e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7abb1090c2fd96f680aad167a48c7dd631ec7f3342fe4403c73e413d3c6571"
  end

  depends_on "pkg-config" => :build
  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
  depends_on "gettext"
  depends_on "glib"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "openldap"

  # These patches are applied upstream but release process seems to be dead.
  # http://www.lichteblau.com/git/?p=ldapvi.git;a=commit;h=256ced029c235687bfafdffd07be7d47bf7af39b
  # http://www.lichteblau.com/git/?p=ldapvi.git;a=commit;h=a2717927f297ff9bc6752f281d4eecab8bd34aad
  patch do
    url "https://deb.debian.org/debian/pool/main/l/ldapvi/ldapvi_1.7-10.debian.tar.xz"
    sha256 "93be20cf717228d01272eab5940337399b344bb262dc8bc9a59428ca604eb6cb"
    apply "patches/05_getline-conflict",
          "patches/06_fix-vim-modeline"
  end

  def install
    # Fix compilation with clang by changing `return` to `return 0`.
    inreplace "ldapvi.c", "if (lstat(sasl, &st) == -1) return;",
                          "if (lstat(sasl, &st) == -1) return 0;"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ldapvi", "--version"
  end
end
