class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftpmirror.gnu.org/gnu/moe/moe-1.16.tar.lz"
  mirror "https://ftp.gnu.org/gnu/moe/moe-1.16.tar.lz"
  sha256 "4c25cd78919272aebec0a7f8c126011bb5a4b5d87422807a3423216f0a17a868"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "cba173e0b7d9ed39604cf1b1b477e5ad68b226a32407e4baca66852d4dce833e"
    sha256 arm64_sequoia: "d9ed67a513eccbbd3034f9013bd36e5703646f92ff1ae81bda02401faefe2604"
    sha256 arm64_sonoma:  "206e78c90a994c5524c93e9df8e399bdcb0c33b0b50cffea0aa501d68cecbe7d"
    sha256 sonoma:        "d3b0b5f33f579a8819e51d46fec8e4b78d8895bef4769eb3e7e801bb250d95c2"
    sha256 arm64_linux:   "108e1f0811bc70ac2310974ef0a996b1b64a3ce21f63d0e497d1a4981ddd8ce4"
    sha256 x86_64_linux:  "6202103a226c7d048c94b241a67b551f1d7bbc09954f21db0672a3b11ce11d50"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"moe", "--version"
  end
end
