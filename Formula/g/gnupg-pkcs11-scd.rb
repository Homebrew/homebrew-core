class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "https://gnupg-pkcs11.sourceforge.net/"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/releases/download/gnupg-pkcs11-scd-0.11.0/gnupg-pkcs11-scd-0.11.0.tar.bz2"
  sha256 "954787e562f2b3d9294212c32dd0d81a2cd37aca250e6685002d2893bb959087"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gnupg-pkcs11-scd[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65d2c6a55292c288781f2242d23e5dd32cbe812de84a34d67d4d9d1843962449"
    sha256 cellar: :any,                 arm64_sequoia: "61fe705d3372be045ef36d9963f239f995fa8eaadfd3a958453bc40779a484ae"
    sha256 cellar: :any,                 arm64_sonoma:  "1a11d7e2b1382db7387cf3fc3d42434b312badc118bde4ec5656e6c64e8b2a91"
    sha256 cellar: :any,                 arm64_ventura: "1651f0fa0cdd511617f7d254d85e5b560150b80b2077607c40178f2b74084dc5"
    sha256 cellar: :any,                 sonoma:        "c5fb594eed11f09d7fa58936b9aaefa5279b500ed06d001177e915a26a551a61"
    sha256 cellar: :any,                 ventura:       "b684dcd097fe3591f06a40af7087f6fe425e926769041fa3cba61d4931122905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f82efd2908e52f5f3bdddb3058d90a6249955cacac286b6d493c74ee2adb947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73d56aaa9f8a96b1bcf700727a25e2bbb89e03aa1e0d456f8e6a418712a29a3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"
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
