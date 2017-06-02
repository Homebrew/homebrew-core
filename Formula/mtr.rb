class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.92.tar.gz"
  sha256 "568a52911a8933496e60c88ac6fea12379469d7943feb9223f4337903e4bc164"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0130688611371db10059beb68d9d9685cfcd0f2836ee7b13f065c23d2c42e645" => :sierra
    sha256 "72fcba3d0131ff90e068ad0076738b95f20d096553cc519eb6107d94b58a2513" => :el_capitan
    sha256 "8a95636a767153b0bf2a6b00136f450d86bbcf6558ca6a4b5b561b2ce86843d7" => :yosemite
    sha256 "7dfd1382e2334613185fef1f749b15a30206c62c2aaeded8c6c8f74007b68ec6" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+" => :optional
  depends_on "glib" => :optional

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV["LIBS"] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-gtk" if build.without? "gtk+"
    args << "--without-glib" if build.without? "glib"
    system "./bootstrap.sh"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    mtr requires root privileges so you will need to run `sudo mtr`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system sbin/"mtr", "--help"
  end
end
