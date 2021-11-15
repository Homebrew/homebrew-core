class Ldapvi < Formula
  desc "Update LDAP entries with a text editor"
  homepage "http://www.lichteblau.com/ldapvi/"
  url "http://www.lichteblau.com/download/ldapvi-1.7.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/l/ldapvi/ldapvi_1.7.orig.tar.gz"
  sha256 "6f62e92d20ff2ac0d06125024a914b8622e5b8a0a0c2d390bf3e7990cbd2e153"
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url :homepage
    regex(/href=.*?ldapvi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7c0302cf11ffe437cf6b52e068adeac5eb3c4f36ad511ce9a77ee62ccc15842a"
    sha256 cellar: :any, arm64_big_sur:  "86cc23b1d8f7bf9b1cf46730d25e0774fa331015e024dfbb5091830c4f73aee0"
    sha256 cellar: :any, monterey:       "b84520d7f99805846e48f305a878a9f41def019d8dc58a9333b88d25811099df"
    sha256 cellar: :any, big_sur:        "79eefa4e1619324c2573a42e688785d5325c4e2d28ef7366ee24a2586a2dd071"
    sha256 cellar: :any, catalina:       "945ba55247fff673cc497f0ef27761790044f9cd337df3d395ca0043ef2ee651"
    sha256 cellar: :any, mojave:         "b227a947ef652d2f335f7ccc7a1334efa2db1fc3a3a6666b35e91310c17548f0"
    sha256 cellar: :any, high_sierra:    "4da9e2cc356624f5b6ad3e6b1c36e934329d80f385d31ac712693d4e8734a4c1"
    sha256 cellar: :any, sierra:         "e6babe3042fee412c0ad7cf89dd95a13d2530d9cd8f6d02c7380bae408ed0040"
  end

  depends_on "pkg-config" => :build
  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.
  depends_on "gettext"
  depends_on "glib"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "readline"

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
