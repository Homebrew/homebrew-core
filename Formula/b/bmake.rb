class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240309.tar.gz"
  sha256 "4336c5e32a7a4026cb731c7a439d3260129e4cbc0f71024cf3dceac1c5814480"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd02f03e96c79048b2948e3051ae8bca472e83630ca137ead9e7129222a3cd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f2f715091a8c8e028e4cefbf16b297d5f888a1e6a775722edef9d2211cfa42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bba266e875451a64d0baac3fda0f8e11ce46a8b3c0cf13bdb1df07bc8a8b089d"
    sha256                               sonoma:         "17b6487e99dfb14f98a71005788cdbae1d7db11e801445dc2c699bca800ad91c"
    sha256                               ventura:        "cc0fc22dd4ad48528e2d6c5f8cd6c610ef68358da23af61e5c28c5eed79cde0e"
    sha256                               monterey:       "dcd0047a2279e3b79d64b7d261afb7aaa76e920cdcda339d57386ed8bb7055fc"
    sha256                               x86_64_linux:   "56da91c54152e11ddbf32e4978ba61445bc797f59ab40235d83956cc90ed4720"
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
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
