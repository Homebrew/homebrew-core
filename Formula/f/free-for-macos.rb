class FreeForMacos < Formula
  desc "Command-line memory status tool for macOS, similar to free(1) on Linux"
  homepage "https://github.com/zfdang/free-for-macOS"
  url "https://github.com/zfdang/free-for-macOS/archive/refs/tags/v1.0.tar.gz"
  sha256 "1c2935d57c144951bd2d9133519d5482ad5e1fdbece15d2ec336c9704222f859"
  license "MIT"

  depends_on "cmake" => :build
  
  def install
    cflags = %q(-O2 -Wall -std=c99 -D_FREE_VERSION="\"${VER}\"")

    system "make", "CFLAGS=#{cflags}"
    system "gzip -c free.1 > free.1.gz"

    bin.install "free"
    man1.install "free.1.gz"
  end

  test do
    system "free", "-V"
  end
end
