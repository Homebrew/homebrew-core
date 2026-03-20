class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.41.tar.gz"
  sha256 "38f2c723eda1d94fd25c91dbad30da7a551a58840b7a6368eaee3daa700fb088"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cb5e54c2ed3c71f2ee65c468d09f5517fd0a907a964ee65239fff10f0cc3e92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ca6ff0e4b9d6cb31e7136b3b3ee3e2bb48cd23f112c516025c78c34213e9208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac4827580d3218212dbf2dd97859b5c95cea622c1dcbe9821ebe6f473be6873"
    sha256 cellar: :any_skip_relocation, sonoma:        "402d67954f91a966b989ef13a06f131d2179c643f7d5dd40ccb3745d52e9fe16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11567a64f191b14ac26cc2d05a805c61a12f76fd2a135e2cc5b7bc06a733d72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d5370cc5ea1c91fa145ba9f59f214d3a87c5c59758e00164d9a18aa3258edc"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
