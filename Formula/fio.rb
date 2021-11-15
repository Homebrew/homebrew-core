class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.28.tar.gz"
  sha256 "135a3455ab6e9251430bb1b12e97151daf4ff5d2d22e8472562c9998a753a04f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8925fb2fe10e1c9dd5de452c62b6d5da5cb6a7839ca284cdcb2853c6d36634d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d5d36dc0b2e846c1ce721c99a5182d32df19af91e123cd7aeb3d76ebdb91585"
    sha256 cellar: :any_skip_relocation, monterey:       "44a5ff7a28fb864e213815f3f4a188ed243ba19138cdac7b6ab88010cb106411"
    sha256 cellar: :any_skip_relocation, big_sur:        "edbda2b51e97d04ac6d43ba0bfd78b87493419c5960ac57f6e7bb378c56139f2"
    sha256 cellar: :any_skip_relocation, catalina:       "3b7487a936c73e0322e68f34ad4b01797524a1f94f2c623d486a7a858f310670"
    sha256 cellar: :any_skip_relocation, mojave:         "0eab936b15e135fad3f2aab2f22504ecd3d8dd98d4b53970a70c24983f546a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f6df69a83a953817b413dcaf89e1da13965c85b2fcdcdeb670303c8743b7e4"
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
