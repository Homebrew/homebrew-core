class Ldapvi < Formula
  desc "Update LDAP entries with a text editor"
  homepage "http://www.lichteblau.com/ldapvi/"
  url "https://github.com/ldapvi/ldapvi/releases/download/1.8/ldapvi-1.8.tar.gz"
  mirror "http://www.lichteblau.com/download/ldapvi-1.8.tar.gz"
  sha256 "359c84d61198c4b4b62930e21670c077c380a41a121f299313330907967949db"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?ldapvi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad2aec84c8f148541274a0c4ba6842d394422a3fd2a2b4fda522f85d2de04609"
    sha256 cellar: :any,                 arm64_sequoia: "0249209d0b49735a766a5748e276e1cf771a1ac7247ee3a3c3dc440721e28a32"
    sha256 cellar: :any,                 arm64_sonoma:  "7f21a70ed40abb81148808896b2263cb6c1fe53afc44e60093af4c179a4f59ff"
    sha256 cellar: :any,                 sonoma:        "a6d7ee2c1782381ee26aafc8ad37d2d6cb6f36867e0148d2fb6b69c28b41812d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dc2d9dc55afa63a8fd1a6a538a28eae84c9251c4f032916e6e0aeeaf941a849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dad790aaa830697230bbfc4e37d8a8ee245d4b066a09679736eed27ab821b43"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libxcrypt" # for crypt.h
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "openldap"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ldapvi", "--version"
  end
end
