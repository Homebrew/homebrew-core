class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-3.0.tar.gz"
  sha256 "80c65159af1e1aeec97f9ddad9f7e213b1abd5f413d1a3dd9ac00a344c6e399d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e91decdaad19c6816f4a7bca87cdf6c2e44dd53e22378f917390e3a43d60ff7d" => :sierra
    sha256 "dea747683bfbb0f99a03f6bd8c30e4f9c02b7811e01ce2c96d4e41e2983aeb37" => :el_capitan
    sha256 "96da6492cf6f0f5e391ac6d1928df6cecf5757dbc3d7cc080f6f19eb7b66c241" => :yosemite
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
