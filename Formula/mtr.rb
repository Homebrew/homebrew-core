class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.87.tar.gz"
  sha256 "ac177953e7c834d5326fc52d63377b6d0b42d05db8017556390629b87e44e183"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
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
    output = shell_output("#{sbin}/mtr --help 2>&1", 1)
    assert_equal "mtr: unable to get raw sockets.", output.chomp
  end
end
