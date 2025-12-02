class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dmg2img[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "0cdc762d353e27c43eacd4221ac499f96a71ac67bd650ceac82d8e8a64f526c2"
    sha256 cellar: :any,                 arm64_sequoia:  "4c3872719a1261f5cd981d5320bba65289e6c2c9e06e73478f3e3bb8267b64ec"
    sha256 cellar: :any,                 arm64_sonoma:   "3abeed11bf75f80c25bfc4f8f3935f8160820623dfb84380ac5b8982ef0498f4"
    sha256 cellar: :any,                 arm64_ventura:  "af9009c8bc805eee1b8b88c88f4323e31f9990476cd61bab48edb90c84c89e4e"
    sha256 cellar: :any,                 arm64_monterey: "03c18ebfadd3f15af4c5acfc3ddff35352b3ed74b734ad1a3f7fc3f991d641c7"
    sha256 cellar: :any,                 arm64_big_sur:  "30d93d8a25986e284ce16234d63262b9b09282194cac91c96e30ef2ac36915ed"
    sha256 cellar: :any,                 sonoma:         "fa89dd61ee460f99225bc6458e4057d94f6ecfbb5a6ca303480562d22e855375"
    sha256 cellar: :any,                 ventura:        "8cb155a0d62a038484e9bda45b83cede96e6410ef20580bf715723c0285ff9eb"
    sha256 cellar: :any,                 monterey:       "5f98d762bda9e92cf497e1bca2cfc1f738da6251c807802cdaf4128b9f6d0972"
    sha256 cellar: :any,                 big_sur:        "0fb916b99c3006b44195e38d0234cb38e1e1aef0c76f73688d75b25d704d689d"
    sha256 cellar: :any,                 catalina:       "f78214ca14fa444d792fd6c9eeec1068717cb64ee8ce635154ccc783bc37099e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "87d9a58139f343a3753c44a15ce9b451dedd5b8e7ef9672dd7b4a2b3f2eb8e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6fe4e0cd5213bfcefed195911e5f7445c0d70016ce01e29ade4fb8dfd8cfa6b"
  end

  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Patch for OpenSSL 3 compatibility
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/dmg2img/openssl-3.diff"
    sha256 "bd57e74ecb562197abfeca8f17d0622125a911dd4580472ff53e0f0793f9da1c"
  end

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output(bin/"dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
