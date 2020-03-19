class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.93.tar.gz"
  sha256 "3a1ab330104ddee3135af3cfa567b9608001c5deecbf200c08b545ed6d7a4c8f"
  revision 1
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a952c5da397d034d9dda48176adc6c95e80817885d7668bb655f3fae5ecd3ddd" => :catalina
    sha256 "4a4715a86749b16145a303a90d872aaf4f30d21f90718cc091db319a76061cc8" => :mojave
    sha256 "a1ce74b90b7647841648e097bc8a3215bca12a050727234486c5ea90c9387627" => :high_sierra
    sha256 "a0c602faaa5af45b8bc5efcc9897a765cc22c1f94411de07ceb32fe5aa721183" => :sierra
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
    # Fix UNKNOWN version reported by `mtr --version`.
    inreplace "configure.ac",
              "m4_esyscmd([build-aux/git-version-gen .tarball-version])",
              version.to_s

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

  def caveats
    <<~EOS
      mtr requires root privileges so you will need to run `sudo mtr`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system sbin/"mtr", "--help"
  end
end
