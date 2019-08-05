class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.93.tar.gz"
  sha256 "3a1ab330104ddee3135af3cfa567b9608001c5deecbf200c08b545ed6d7a4c8f"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b137ed40e6196bb62c8b2be59f28af343158d3e519f90df68e67d02b36e77e62" => :mojave
    sha256 "b5ca93ad60fb8c02abf439ce6de67209aa4bee842b609cd30e99ecd19fae2589" => :high_sierra
    sha256 "9dc3aed9968b410bb895471a9f8630e4685c9c70ab606f64d97b70ca8772fadd" => :sierra
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
