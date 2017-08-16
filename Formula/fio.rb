class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-3.0.tar.gz"
  sha256 "80c65159af1e1aeec97f9ddad9f7e213b1abd5f413d1a3dd9ac00a344c6e399d"

  bottle do
    cellar :any_skip_relocation
    sha256 "57032a96c608995957c7936f6eb34af53988eb896baafbaee1e4a5527d82d8df" => :sierra
    sha256 "8e487bd8fdd8d9f4c300fd22983d6b1922ab108f2ae6bf31c56978ddd0d83464" => :el_capitan
    sha256 "e569ca45cdf8e66351232b44bf5814be2dfeb0cb0ee3367cfa685f6e04136536" => :yosemite
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
