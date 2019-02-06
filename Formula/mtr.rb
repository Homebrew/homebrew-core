class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.92.tar.gz"
  sha256 "568a52911a8933496e60c88ac6fea12379469d7943feb9223f4337903e4bc164"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ec13c29bb5e49ffbe0a9c83da77313c28b6bed60da1eb923945130f74158212" => :mojave
    sha256 "3e426bdf04070ab31f2e70fae91a5b576ced3072733d5e9a0b617c75e97202bf" => :high_sierra
    sha256 "0558426657c36a32f26d65c96b6111753f7189b5b198715df33b9a4f64e25732" => :sierra
    sha256 "1700c0b67f337a9089de95ded89391be790ad440336b252be1d109b9b8352cc7" => :el_capitan
    sha256 "90aa1e5d224e98d572525b09715390f0fbf2b72954cd3c0b87b9cd6af6ff8ac2" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-glib
      --without-gtk
    ]
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    mtr requires root privileges so you will need to run `sudo mtr`.
    You should be certain that you trust any software you grant root privileges.
  EOS
  end

  test do
    system sbin/"mtr", "--help"
  end
end
