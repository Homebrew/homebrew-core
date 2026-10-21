class Ldapvi < Formula
  desc "Update LDAP entries with a text editor"
  homepage "http://www.lichteblau.com/ldapvi/"
  url "https://github.com/ldapvi/ldapvi/releases/download/1.8/ldapvi-1.8.tar.gz"
  mirror "http://www.lichteblau.com/download/ldapvi-1.8.tar.gz"
  sha256 "359c84d61198c4b4b62930e21670c077c380a41a121f299313330907967949db"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?ldapvi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c6b799d347aecd76ac20a01a8213e62085f9e9e58455f95a9ae86188340ea36d"
    sha256 cellar: :any, arm64_tahoe:       "7513b0860ba84275ccdf408af93c082de9e9823e64a8ce7f71bca1b440c55826"
    sha256 cellar: :any, arm64_sequoia:     "3f23ec23b01b2fc109822508fe456353d933a26258b5365b0f75f8ccda6db240"
    sha256 cellar: :any, arm64_linux:       "af770777c23b7189ef30d53283a0054510a9a2172a8f7e3e9d67598b05936591"
    sha256 cellar: :any, x86_64_linux:      "43a5645d5a28bb5646e07acd82bb5d22e97e86e172ac3d9545326d468fd61134"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "libxcrypt" # for crypt.h
  depends_on "openssl@4"
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
