class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20250414.tar.gz"
  sha256 "43258a0b819f3e362dd66c05b8212ea977606945f3887ba1b6ad612affabc9aa"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcb77e6358390c80463b999d8979ceae3e69a3e5e3cf8d05a44a98a96d05f57a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "230aae790cc684473ea54bd90bd7933214a41de7b4ced82083b19da564470b58"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "170947e3fff8897d4dc593e4f9f7b14adc58cd1e0d926b711602c109f062a49d"
    sha256                               sonoma:        "a0c140bba308f37cf40fe5fe83e9a377e71a084649a302cc8a494eb6876395c5"
    sha256                               ventura:       "3963568a17f0874afc6b8681c17f670528bc69fa059704afc3259e2d52db7b88"
    sha256                               arm64_linux:   "9efc697537e519aaf95d3207b689301142729ad7ca26c8a8e792eea15e535b1a"
    sha256                               x86_64_linux:  "5aaa87b011f69dc54471377b0014bc8f2e9ffb4030d454862446d09dbe6262ee"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
