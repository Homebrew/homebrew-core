class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.42.tar.gz"
  sha256 "56b03497a918d07692257890fd759bf73168ad79df5be78a2bcbbdc8ce67895b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "611c21aa09abf75e1df6e31658b1bf04182e7b7c678a0b29bb978cf15e2cbb9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4f2a8dab06afd2289586c52856e49777630e387161a3cc791ffe1ecb54dbf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb7a4ffae3b6efc4de0cd489f458448eeacf4a1226711a2443ab48dd0b6accff"
    sha256 cellar: :any_skip_relocation, sonoma:        "960759c937bf7dc1e54d4605ef912a443ced521e4531062e29c856af476add9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc1623f397fd345e7bcec43a36a9e679a20d108281c1f3581f67b03cfb599a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8539bfd65ae2df6839534e907f291e50943eab0df04bb9513b868a45ce6e5247"
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
