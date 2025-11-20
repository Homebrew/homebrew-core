class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "1b74b58e16dfa7a846bbe3135a7deaf2da54da009aa9d6f63340b3a046add319"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a203863decd6e32077b5596b28d7ff5f3d7add64c3185d4308d5175dc2e8659"
    sha256 cellar: :any,                 arm64_sequoia: "42fd1d0dbc4ed108675af031cde76aa65216d36f5eb5716ac16248998014ce6c"
    sha256 cellar: :any,                 arm64_sonoma:  "bb2c609176152b4fe82c1b3a61411388d8e2ba22a72a30722e1f82507e402125"
    sha256 cellar: :any,                 sonoma:        "f1895991433aadeddb6c7a75a838b1b39c192fafe5958b5e1925d7c6195871ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e0e2ad726ff8ab3d891ebf44f3f020e16ab49a0eade592a3aeced3de419f6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48f7c1063e36f2d139855e443c713a7d9d3bbc691b042d76717a2684217b15f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--enable-readpcap", "LEXLIB=", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
