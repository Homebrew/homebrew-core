class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.net/"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.11.0/gnupg-pkcs11-scd-0.11.0.tar.bz2"
  sha256 "954787e562f2b3d9294212c32dd0d81a2cd37aca250e6685002d2893bb959087"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8b0bdb58d5901c55a9440e26aa4517cc7adcd9b11b986a48459ec08fcffa5a46"
    sha256 cellar: :any, arm64_tahoe:       "b11527d4954e4186110bae684771152f7469f62bdf801b237ca835fe90ce7543"
    sha256 cellar: :any, arm64_sequoia:     "c9429a21c0bf49b31071791099d6ed2ca39ef83739bc7ceabf1503c6c2f6bc4a"
    sha256 cellar: :any, arm64_linux:       "33e84c7d2e70d23d562326c74b1ee73e776ef00b7fd478ff044722fb123cb89c"
    sha256 cellar: :any, x86_64_linux:      "57ec2397088bc335b24efb808c62f826e948004b9d01a3a5f25c0a34b4a1ea4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@4"
  depends_on "pkcs11-helper"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"gnupg-pkcs11-scd", "--help"
  end
end
