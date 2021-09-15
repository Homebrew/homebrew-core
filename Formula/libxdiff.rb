class Libxdiff < Formula
  desc "Implements diff functions for binary and text files"
  homepage "http://www.xmailserver.org/xdiff-lib.html"
  url "http://www.xmailserver.org/libxdiff-0.23.tar.gz"
  sha256 "e9af96174e83c02b13d452a4827bdf47cb579eafd580953a8cd2c98900309124"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?libxdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "f986d3e17b2ca9bf61f85fb8dffe837edbd5bee22b1c21c27f3ecfea9a83b12b"
    sha256 cellar: :any,                 big_sur:       "bb4777447c50173e1edd3a65eb75559a4ec8f14621f01cdc40b639b86e206162"
    sha256 cellar: :any,                 catalina:      "bb5dedb22ce363d4c6b8f46d3059dc81d68ba3627aaaff8efcdaa6c6b2c2ea37"
    sha256 cellar: :any,                 mojave:        "9d9c3f473efd5d1a2edc928e12e12552cacbc40183042945b3bbef47532145e4"
    sha256 cellar: :any,                 high_sierra:   "46a8499130fcdafc69e79436a77338398139b7ac54b3ae5f0ca9ba75b9f7efc9"
    sha256 cellar: :any,                 sierra:        "4a29b90dc48e4ce505bb50e575cc91107df8d93a90fe49ab4ec02df6118158ec"
    sha256 cellar: :any,                 el_capitan:    "55d89877bd5457b7a5b77cf68187f544ff413228ec17a701e7879644ae528f35"
    sha256 cellar: :any,                 yosemite:      "6269c8d291cea44aceda9bd8e1e93a061e64d76852e47b781ae49aee28f0c31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b3220efc3c97fefbe4ec212663fe86de66179d36fb974377790d72ebd5ed41"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
