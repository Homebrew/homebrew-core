class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.30.tar.gz"
  sha256 "305647377527a2827223065582dd8a9269e69866426b341699d55bb4e4d3cc71"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e6c68228927de946af436462430570baa8a76a1c671fb3164859dd40d645bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db7765c3d2e3f844d39f1856142e02e9805e733a66a6d7eee0e328a3f830744d"
    sha256 cellar: :any_skip_relocation, monterey:       "73784fe2a10c41133ae795e2cefa5bb0abeb523caaa8094f03d0fdeeecea260b"
    sha256 cellar: :any_skip_relocation, big_sur:        "23f365e06226826d7721235d5854dda333ad4e6b958376fbf5164a18b67c42a1"
    sha256 cellar: :any_skip_relocation, catalina:       "b0c3cc845dbebc6f7539cce887926876ea3bde736cb3fee0f50acd9c2f2f7680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9081d3d0bcc57384a19805690d692cc35861e2f7b0dff788140964c9ab501e31"
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
