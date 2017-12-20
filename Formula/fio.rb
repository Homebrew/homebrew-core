class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.3.tar.gz"
  sha256 "75e2ce17e17918eb4e79d4ac46d99ba1a5e7c0808b7973fb191c6177b2e5755a"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb9cbd7d0e3e643c4b738de0d5e92c87c527634fffd4997b274df1d5b7e45092" => :high_sierra
    sha256 "71738bee1b494455191c385f966d3e0c1ac4c23f04a568485453522383cf1f60" => :sierra
    sha256 "a38e68a9fbd176a015f24923e7a61d6558d92992843ffba9c63c1c2e48062cc6" => :el_capitan
  end

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
