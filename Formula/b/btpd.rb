class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz"
  sha256 "296bdb718eaba9ca938bee56f0976622006c956980ab7fc7a339530d88f51eb8"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "bdde460a80660a0afd8811c961ffd495be84550578f4a3125181605438500e0f"
    sha256 cellar: :any,                 arm64_monterey: "78f27d75fcd843c49964eb16b4391a4f356aa608738ec4783baccba2636f5a0b"
    sha256 cellar: :any,                 arm64_big_sur:  "0e4467a0d042844b00c6b5f896468dada066d0372e060d788733afada425b87b"
    sha256 cellar: :any,                 ventura:        "f98d0960732c2ba02a8c8335ca94f5f49a36723e7107490a8154cd7fe85b65d2"
    sha256 cellar: :any,                 monterey:       "423f7dc95d5fbb92a4e8cefdca992b20eb20e3a4548248281ed5d135a6a675c8"
    sha256 cellar: :any,                 big_sur:        "0a69fd078eb310b051cc151295ec20619a5aa8309adde05fc281a66bf7652df5"
    sha256 cellar: :any,                 catalina:       "e3aaa9dc2e6cafa9e9a2672fe9bad6da2871e1f496029ad2f12004c6c24f0895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "483442aed198f237fd3d92bde41c2b12db3e150e44bab84bd2fab6d96a25d8c5"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Torrents can be specified", pipe_output("#{bin}/btcli --help 2>&1")
  end
end
