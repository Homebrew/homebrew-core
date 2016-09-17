class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "http://freecode.com/projects/fio"
  url "https://github.com/axboe/fio/archive/fio-2.14.tar.gz"
  sha256 "9fad9dd4d6304f1220023500abf07c5d20bf5e27fba95ac6edb7035939d363a5"
  head "git://git.kernel.dk/fio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22836835822072ba50423e9f4602a2307c1f6f3da1a495ff167f5186ab2f1d0d" => :el_capitan
    sha256 "192afda69fa661b0a7c055b6b5fdcc000bac74933452f6a13bb38a3cc44879cf" => :yosemite
    sha256 "06d87d4865923cd577eb8a34819abe07d00c8f68b4129ae8cbadec1570f447ea" => :mavericks
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
