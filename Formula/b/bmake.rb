class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240314.tar.gz"
  sha256 "f9a906d7487699c9e0d2c135700c2d088da5fcd0f2f6761267a57aabfea31feb"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c388d3cf0c031928547d9142e37014f1ba98354e4efc6bbc123e6b2d68da934b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00cb273566767ad88d0da92423579e70dd8b86c6c53514e85508443554c03ecf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8c14d95578927a3a03c3c750f4a1896b09eb9af0d872afbaf5ee65de818f5d"
    sha256                               sonoma:         "5454f57f4e8c50c42962eaa9b3ffe57dc16968d6b851b6f610f4a78452a6f590"
    sha256                               ventura:        "5a4f4e894425347f375b138a915f9ca367a70296b3eb820b4f2f51d0928bb9ae"
    sha256                               monterey:       "6898464057e0305dbee3211b0b1faca12c46595783dc72e8175fff44fe9e2e8f"
    sha256                               x86_64_linux:   "7142d7870f43f2c4737dab89be0b7c44b73bdd56b3f622710cfd3e75cbdedfe0"
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
