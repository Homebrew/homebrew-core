class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.39.tar.gz"
  sha256 "e2f4ff137061b44ceb83a55eb9ca8856fe188db6d9b00cb59f8629c9162afe0a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d18e22916e18eaf7cb1422de669df9a988949303cb1acf981e9f2ba177a9489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "223012be7afd1fbab0bfa118ce1b2568dd2e3ecc10c40864527c3158012fcd5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89a8142a97e2c12770689292796870b88cea1a2e7b3905acc9a12367c2824066"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bbf859ba02c06a4635c1593eaa02079717f084efa5c2c2a6f70e9ccc5d37f09"
    sha256 cellar: :any_skip_relocation, ventura:       "87de1303a14d5cef747d4a1e088a9c25229071d2c7bddeba24131d0e7716dc74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d0586d9c191f688bb3250e83946395816d4fb6bb84f0e024fbe6e335ed1bba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9575eda2dcf3407132b222e95d4410bdf7451271c91b327e5cb31c5ba512ada"
  end

  uses_from_macos "zlib"

  conflicts_with "fiona", because: "both install `fio` binaries"

  def install
    ENV.runtime_cpu_detection
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
    system bin/"fio", "--parse-only"
  end
end
