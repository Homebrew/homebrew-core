class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://git.kernel.dk/cgit/fio/"
  url "https://github.com/axboe/fio/archive/fio-3.7.tar.gz"
  sha256 "15643de9c02b8ccae0dac287c5f421a7271d81b2600d6ed87b40e430a9f444b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "29322c22a378a947289077a5aeb0a479e99844efbad45006299e8ccf8607b56b" => :high_sierra
    sha256 "1b70a99c3c6e9a34002a058693ffed521cca80df607fed18d8055a79acea0775" => :sierra
    sha256 "15d519e7864da6d73375db33aac16541a0b14a60c6516a2c7af4a84737becb99" => :el_capitan
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
