class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/btpd/btpd/archive/refs/tags/v0.16.tar.gz"
  sha256 "9cda656f67edb2cdc3b51d43b7f0510c4e65a0f55cd1317a7113051429d6c9e5"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "443e5953a4dfc4ad62c70af0b005319addca1a381706b7f74ec364d64436d944"
    sha256 cellar: :any,                 arm64_sequoia: "98ca814695b7f123be0d98c663acd5eb336ed86edfb24845956048681bcc6619"
    sha256 cellar: :any,                 arm64_sonoma:  "3462192cebb497fc0b3d3708dc7283828d3b4038b57a1afd6aad524a0c16242f"
    sha256 cellar: :any,                 sonoma:        "8a36cd0aa7a799036a588f072e655d5f51c070f15630e1dc73738357e7f7ce85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c327b14b664ca3d0a9f809935cb60fa22c33d9aed01d89769eb0add2563d438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79944005ef448f93892750b085fe71bff152c92f0ff0f0713fcfaa4219137141"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@4"

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
