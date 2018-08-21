class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.8.1.tar.gz"
  sha256 "f5718e316771571971cb4e5a0142f91b47c6bfe32997fd869fc5a90ec091a066"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7fa3d823b125697f59f95c5671ddc591b91223e45cc59555ee62de7e5df752d" => :mojave
    sha256 "0dee597cc5870323ea38804337d3c3bd7b681a53303031399d31c12e1c1f1f55" => :high_sierra
    sha256 "054b42c0cb78315e454759303b7f25945a9ed18ee76f32a14d58a6911861f37d" => :sierra
    sha256 "64a97a9de695bc96f596d5a626428b8758ae0365b67c161bcd9519ccdf7dcfc4" => :el_capitan
    sha256 "ea221a1093f4bdb63209c30fc29a888ae5312baa9f50f1bc8c5b56dac75cbb46" => :yosemite
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
