class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/btpd/btpd/archive/refs/tags/v0.16.tar.gz"
  sha256 "9cda656f67edb2cdc3b51d43b7f0510c4e65a0f55cd1317a7113051429d6c9e5"
  license "BSD-2-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "9670afe44796531465fa7394a409a946f16512995eaa9405ad263fcb72bd469f"
    sha256 cellar: :any,                 arm64_sequoia:  "29e7c1076df7e76f28cd672d7fd4e9c87ddf6d21ddca353cf1014906b9fa594d"
    sha256 cellar: :any,                 arm64_sonoma:   "6fd9324f811eb0e07e6a3ca529424a00b4a1ddd6d7ce88601b5f1c51cf91d89c"
    sha256 cellar: :any,                 arm64_ventura:  "bdde460a80660a0afd8811c961ffd495be84550578f4a3125181605438500e0f"
    sha256 cellar: :any,                 arm64_monterey: "78f27d75fcd843c49964eb16b4391a4f356aa608738ec4783baccba2636f5a0b"
    sha256 cellar: :any,                 arm64_big_sur:  "0e4467a0d042844b00c6b5f896468dada066d0372e060d788733afada425b87b"
    sha256 cellar: :any,                 sonoma:         "77c89315bf5e63b47de72fbd3c17d3182d2d73c5bf2a341840bae4d7ea8b2bfe"
    sha256 cellar: :any,                 ventura:        "f98d0960732c2ba02a8c8335ca94f5f49a36723e7107490a8154cd7fe85b65d2"
    sha256 cellar: :any,                 monterey:       "423f7dc95d5fbb92a4e8cefdca992b20eb20e3a4548248281ed5d135a6a675c8"
    sha256 cellar: :any,                 big_sur:        "0a69fd078eb310b051cc151295ec20619a5aa8309adde05fc281a66bf7652df5"
    sha256 cellar: :any,                 catalina:       "e3aaa9dc2e6cafa9e9a2672fe9bad6da2871e1f496029ad2f12004c6c24f0895"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d051486a6fae13f53a4478ae31ad45cf05bf067727ef83f5c77836ac5526b18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "483442aed198f237fd3d92bde41c2b12db3e150e44bab84bd2fab6d96a25d8c5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  conflicts_with "btcli", because: "both install `btcli` binaries"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Torrents can be specified", shell_output("#{bin}/btcli --help 2>&1", 1)
  end
end
