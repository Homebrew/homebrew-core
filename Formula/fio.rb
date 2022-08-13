class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.31.tar.gz"
  sha256 "077100819a243d0e00f232eb7c53fe1d30f4c54fba4d82847d5747eae1d255ab"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6af40c3d39cd9bf09446f954141f3234da2f6abb483d238481e707e04f07528c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91dc44382f9e77161d9075a0bf7c0b86e2853859081e1c992c204d2af14bfb2f"
    sha256 cellar: :any_skip_relocation, monterey:       "f2124878f0bed80dc97ac723a2b62591c409b674ef39dc6eb828dff77ee1523c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20d28f72b0b5f71baa781dcfcc42eb3a0d367e78fec6fe41e6baf55eada4142"
    sha256 cellar: :any_skip_relocation, catalina:       "97a550b744668541222684b9ceafb452ce25d869ab41620c05fa28804b5bdf0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57394fe45fb3bdd950bb93aa8dc02cd742c3ac6da9c0ee6778199c5180f0efe4"
  end

  uses_from_macos "zlib"

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
