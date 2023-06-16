class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230601.tar.gz"
  sha256 "8d0b2e593946539065530a241040b0b0525ebb2b924ed67fc497ad17845a5a09"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e08a313ec6c2e4b2ea63af8da54824620f1196ba44d05e9b67fa64e06cac73e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9feb49f7a9f52d4141b729adb9ccb6a34b2efe8cb067650caf18f487facde284"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aee3e26830e50c93c3db4c8d259ae2b04c433bd210a67725fdfaec9693a7242a"
    sha256                               ventura:        "1c9a542c4a9c9c214bb1b23425eea5afa562df20a970aefd102bc1f804bb3294"
    sha256                               monterey:       "d7a056a519564d7672630eeae8fc4beb6ad9cc699865aa4b55e65cb5e68beaa6"
    sha256                               big_sur:        "d209760faea96862d58279239d1c82d00ad1c817d26f16eab995161fda921793"
    sha256                               x86_64_linux:   "235a2bdf9c32c28d73c877dbfdbd9bd476178906d0b6b0d815b6fc1e0f328537"
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
