class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.16.tar.gz"
  sha256 "c7731a9e831581bab7104da9ea60c9f44e594438dbe95dff26726ca0285e7b93"

  bottle do
    cellar :any_skip_relocation
    sha256 "1116adcef2bd9c6d6b34411204869d22a32d9b1345cc057d7bcddda25a5fcb95" => :mojave
    sha256 "4ef16a70bb44172f46b13b0238401b397514b612ab093049ca2160efd84973f1" => :high_sierra
    sha256 "d8deeeb178958d1811c15b1263553de705e14943c311aa673fb337bf8787c9b7" => :sierra
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
