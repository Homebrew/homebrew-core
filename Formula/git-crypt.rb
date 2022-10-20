class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.7.0.tar.gz"
  sha256 "50f100816a636a682404703b6c23a459e4d30248b2886a5cf571b0d52527c7d8"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?git-crypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c3cbd37781dd58b4aad1cf13691732efe32d34f04e0e8eac3e2895821bba31b5"
    sha256 cellar: :any,                 arm64_big_sur:  "7dd2f73df766f03acd350528daf8f91b742f7fafa0990feed4fc32db5a27b831"
    sha256 cellar: :any,                 monterey:       "c1c9d3d31a6543b0001985753e5d9e8b59bee25e5b7546987f88ef0f8db97135"
    sha256 cellar: :any,                 big_sur:        "f07ef5d8ce3559f23e140fdb21f31ca3ddfa29d75f35627996739e31560fec83"
    sha256 cellar: :any,                 catalina:       "eee30c6825d5a0f0b5746ea15d393d5004f78c9594cf6eae916b4ded49874958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "954789caa6a1822c2f2fc02248c6607c0557184c803d6b0e545907457858f3bc"
  end

  depends_on "openssl@1.1"
  uses_from_macos "libxslt" => :build

  def install
    system "make", "ENABLE_MAN=yes", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
