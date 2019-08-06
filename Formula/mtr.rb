class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.93.tar.gz"
  sha256 "3a1ab330104ddee3135af3cfa567b9608001c5deecbf200c08b545ed6d7a4c8f"
  revision 1
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "897b799ceac2677da540387c4015d4f520f59bf9965bcf1b5b1e9dd706bf3778" => :mojave
    sha256 "b0348961fef4e2b805434587d69cd6f2caecc3ed2c21873211635e6a875a4562" => :high_sierra
    sha256 "cffaaf2cacad93387e7f32bcbb38e8dd1be2d2615774baa96ed320021e564011" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  # Pull request submitted upstream as https://github.com/traviscross/mtr/pull/315
  patch do
    url "https://github.com/traviscross/mtr/pull/315.patch?full_index=1"
    sha256 "c67b455198d4ad8269de56464366ed2bbbc5b363ceda0285ee84be40e4893668"
  end

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
