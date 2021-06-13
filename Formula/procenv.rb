class Procenv < Formula
  desc "Command-line utility to show process environment"
  homepage "https://github.com/jamesodhunt/procenv"
  url "https://github.com/jamesodhunt/procenv/archive/refs/tags/0.56.tar.gz"
  sha256 "ffd186f479aa33194ef6070555011b356526c18bf4c2bce6c65f3ada4eebce5d"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/procenv")

    assert_match(/^compiler:$/, output)
    assert_match(/^cpu:$/, output)

    assert_match(/^environment:$/, output)
    assert_match(/^\s+HOME: #{ENV['HOME']}/, output)
    assert_match(/^\s+USER: #{ENV['USER']}/, output)

    assert_match(/^memory:$/, output)
    assert_match(/^meta:$/, output)
    assert_match(/^process:$/, output)
    assert_match(/^sysconf:$/, output)
    assert_match(/^tty:$/, output)
    assert_match(/^uname:$/, output)
  end
end
