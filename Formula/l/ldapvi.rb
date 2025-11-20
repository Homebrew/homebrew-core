class Ldapvi < Formula
  desc "Update LDAP entries with a text editor"
  homepage "http://www.lichteblau.com/ldapvi/"
  url "http://www.lichteblau.com/download/ldapvi-1.7.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/l/ldapvi/ldapvi_1.7.orig.tar.gz"
  sha256 "6f62e92d20ff2ac0d06125024a914b8622e5b8a0a0c2d390bf3e7990cbd2e153"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url :homepage
    regex(/href=.*?ldapvi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "74bc513ed1c36a4f5f71454e94d55bdf2386ec43c5d84106d54615f5c29d3b48"
    sha256 cellar: :any,                 arm64_sequoia:  "619197cac0a0f9f7c8df2d5ced5e42f95e421c645ae87b7ae0d44048cbec6359"
    sha256 cellar: :any,                 arm64_sonoma:   "1a498cb6fd5153f82c0cfd2a9133dcaf68c280f3da4fa641abdcde5d0d2c4311"
    sha256 cellar: :any,                 arm64_ventura:  "a3ad41b60a3da8e819b1abec997f49b3912addab32ffde4c5e12b7b747c5e86f"
    sha256 cellar: :any,                 arm64_monterey: "63919baa17c57b8a12fa108dbfe0f4c8dbf3c591be3b8fad01f0750cca17be95"
    sha256 cellar: :any,                 arm64_big_sur:  "5489222c138f0e9d354ab8aa153d30baa870a2c15410bb18a134a396563c1645"
    sha256 cellar: :any,                 sonoma:         "fbb82855e629c75015862b1f4210a318181b11e0b964ebc6b3355d77437c9965"
    sha256 cellar: :any,                 ventura:        "2f876c4180027df3eb3f619f62a72b46969292b348f8c8944d3adb99117746ea"
    sha256 cellar: :any,                 monterey:       "d0a155ea5d43cf0f5917acd48cccd30383cab9b9dd7754eeca465da2b15da8dc"
    sha256 cellar: :any,                 big_sur:        "e7738f50126f4a4b5890215ddb63e85d246729a31e1cd8a260e7dfc45251db9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f686aa703ff6be2ac2d15a1624e129e168f89f96a9853dbae572c3c16d170004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2deb6f280d0b64a18c53e61aa77b2e46d0907ffe56f30ca81e71ae4447e3a5"
  end

  depends_on "pkgconf" => :build
  depends_on "xz" => :build # Homebrew bug. Shouldn't need declaring explicitly.

  depends_on "gettext"
  depends_on "glib"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
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
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Fix compilation with clang by changing `return` to `return 0`.
    inreplace "ldapvi.c", "if (lstat(sasl, &st) == -1) return;",
                          "if (lstat(sasl, &st) == -1) return 0;"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ldapvi", "--version"
  end
end
