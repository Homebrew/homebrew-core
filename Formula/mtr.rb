class Mtr < Formula
  desc "'traceroute' and 'ping' in a single tool"
  homepage "https://www.bitwizard.nl/mtr/"
  url "https://github.com/traviscross/mtr/archive/v0.87.tar.gz"
  sha256 "ac177953e7c834d5326fc52d63377b6d0b42d05db8017556390629b87e44e183"
  head "https://github.com/traviscross/mtr.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fba272c1219a2386b034110dc129fa484597e7865b544d979386e0bfa0bc7f2e" => :el_capitan
    sha256 "96c3b22edc936bb9b7053a1920f34a524fdc3a6d99d32f5c6313a903d6b3ff1f" => :yosemite
    sha256 "3fb9172a95469e6ee38faeee2e67682f75dd79a6e222426674751846fee5f0a9" => :mavericks
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
