class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.20.tar.gz"
  sha256 "eb51fbad161929f1bcd6c1d0d09d2c7543651f834aec860ba5def9bc52dcc3ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "779c7c979c77ded0d4d403e30cef4cfcc324d56836424a3bb134fdb436fa32da" => :sierra
    sha256 "5922184225d1d2ed8300ee7da92bfc107caee5f35d5d0a3c3ff25bb455ea040a" => :el_capitan
    sha256 "5c034f4614df9d08b5f63362bb6a6fab500f34ae22fbe21c0b27e1cf2bd3ee07" => :yosemite
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
