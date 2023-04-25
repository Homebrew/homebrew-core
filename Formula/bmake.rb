class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230414.tar.gz"
  sha256 "29cb1d26aae7de9def92bdaeb3aad4520e89951ce97b2e75f0b89bae1b95399f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb18a707f5ead310be24272b896cb60daf586406945db9a225096b9fe85c528"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7795ad41da9e56e75311fa190575a43a0fe60d8f695d87c5c45be768d7b848dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a10e165e50e7df4b8dac02780fad57349ca76b9548a913e444b00a4ce2cc344"
    sha256                               ventura:        "613e0613f03ec2d5545860bac802cbacdd13ea5d4738c9ed6d558de7957d9384"
    sha256                               monterey:       "6f71be3dfd61457deac47dd77b2e603c982c6829b62b8b8c4be93355d9b83748"
    sha256                               big_sur:        "f1667042407718b66c6b150b0ef9b13716a81b737ce8d677b09e3ecf578980af"
    sha256                               x86_64_linux:   "9d1cd4452824e0fe7ae9b333f6ba682c39ebd5373f212c48ce37dbc3f3754452"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

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
