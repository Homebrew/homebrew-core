class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/refs/tags/fio-3.40.tar.gz"
  sha256 "9fc81e3a490a53fe821d76dd759d64f229d0ac6b4d2c711837bcad158242e3b2"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8b504d3c62bbce8a96efc01c00ec5b15f88bd9437f70c591337bf00f0626bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba52e1f825848a101aeb18e688c55475860e8b5a9da0eb477bc43937260aa4d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f3091669df862a3f00777bb99dadd95dc53134cb7fa680312bed8d95003b141"
    sha256 cellar: :any_skip_relocation, sonoma:        "be7e0fd80ca53413a6088a2ff4893fa070d228d619129a1cf603255a1af37037"
    sha256 cellar: :any_skip_relocation, ventura:       "d02aec7122860d588cd7c7876dd14361a1f14f95b950b708ec6cb6ad907f1136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4fa34b174d429c002102c6ae454922caf983339a2cb7ded9bbbf0dc29e2e226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c41753bb19a895a1d21cb9d89e367846c171aefc177aa869c1bc3a54605437e6"
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
